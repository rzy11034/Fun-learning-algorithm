﻿unit FLA.Algorithm_02_04;

{$mode ObjFPC}{$H+}
{$ModeSwitch advancedrecords}
{$ModeSwitch unicodestrings}

interface

uses
  Classes,
  SysUtils,
  Math,
  DeepStar.Utils;


procedure Main;

implementation

type
  TEdge = record
    V1: integer;
    V2: integer;
    Weight: integer;
  end;

  TPair = record
    V, Weight: integer;
    constructor Create(newV, newWeight: integer);
    class function Comparer(constref a, b: TPair): integer; static;
  end;


const
  N = 5;  // 城市的个数

  EDGES: array of TEdge = (
    (V1: 1; V2: 5; Weight: 12),
    (V1: 5; V2: 1; Weight: 8),
    (V1: 1; V2: 2; Weight: 16),
    (V1: 2; V2: 1; Weight: 29),
    (V1: 5; V2: 2; Weight: 32),
    (V1: 2; V2: 4; Weight: 13),
    (V1: 4; V2: 2; Weight: 27),
    (V1: 1; V2: 3; Weight: 15),
    (V1: 3; V2: 1; Weight: 21),
    (V1: 3; V2: 4; Weight: 7),
    (V1: 4; V2: 3; Weight: 19));

var
  dist, path: TArr_int;
  map: TArr2D_int;

  // 如果 visited[]等于 true，说明顶点土己经加入到集合s；
  // 否则顶点土属于集合 v-s
  visited: TArr_bool;


procedure Init;
var
  i, j, v1, v2: integer;
begin
  TArrayUtils_int.SetLengthAndFill(dist, N + 1);
  TArrayUtils_int.SetLengthAndFill(path, N + 1);
  TArrayUtils_int.SetLengthAndFill(map, N + 1, N + 1);
  TArrayUtils_bool.SetLengthAndFill(visited, N + 1);

  for i := 1 to High(map) do
  begin
    dist[i] := MaxInt;

    for j := 1 to High(map) do
      map[i, j] := MaxInt;

    visited[i] := false;
    path[i] := -1;
  end;

  for i := 1 to High(EDGES) do
  begin
    v1 := EDGES[i].V1;
    v2 := EDGES[i].V2;

    map[v1, v2] := Min(map[v1, v2], EDGES[i].Weight);
  end;
end;

procedure Dijkstra_While(s: integer);
var
  v, w, curDist, curIndex: integer;
begin
  dist[s] := 0;

  while true do
  begin
    curDist := MaxInt;
    curIndex := -1;

    for v := 1 to N do
    begin
      if (not visited[v]) and (dist[v] < curDist) then
      begin
        curDist := dist[v];
        curIndex := v;
      end;
    end;

    if curIndex = -1 then Break;

    visited[curIndex] := true;
    for w := 1 to N do
      if (not visited[w]) then
      begin
        if (dist[curIndex] + map[curIndex, w] < dist[w]) then
        begin
          dist[w] := dist[curIndex] + map[curIndex, w];
          path[w] := curIndex;
        end;
      end;
  end;
end;

procedure Dijkstra_For(s: integer);
var
  v, w, curDist, curIndex, i: integer;
begin
  for i := 1 to N do
  begin
    dist[i] := map[s, i];

    if dist[i] = MaxInt then
      path[i] := -1
    else
      path[i] := s;
  end;

  dist[s] := 0;
  visited[s] := true;

  for i := 1 to N do
  begin
    curDist := MaxInt;
    curIndex := s;

    for v := 1 to N do
    begin
      if (not visited[v]) and (dist[v] < curDist) then
      begin
        curDist := dist[v];
        curIndex := v;
      end;
    end;

    if curIndex = s then Break;

    visited[curIndex] := true;
    for w := 1 to N do
    begin
      if (not visited[w]) and (map[curIndex, w] < MaxInt) then
      begin
        curDist := dist[curIndex] + map[curIndex, w];
        if dist[w] > curDist then
        begin
          dist[w] := curDist;
          path[w] := curIndex;
        end;
      end;
    end;
  end;
end;

procedure FindPath(s: integer);
var
  stack: IStack_int;
  i, x: integer;
begin
  stack := TStack_int.Create;
  WriteLnF('源点为%d', [s]);

  for i := 1 to N do
  begin
    x := path[i];

    while x <> -1 do
    begin
      stack.Push(x);
      x := path[x];
    end;

    Write('源点到其它各顶点的最短路径为：');

    while not stack.IsEmpty do
    begin
      Write(stack.Pop, '--');
    end;

    Writeln(i, '; 最短距离为：', dist[i]);
  end;
end;

procedure PrintGraph;
var
  i, j, m: integer;
begin
  for i := 1 to High(map) do
  begin
    for j := 1 to High(map[i]) do
    begin
      m := specialize IfThen<integer>(map[i, j] = MaxInt, 0, map[i, j]);
      WriteF('%4d', [m]);
    end;

    WriteLn;
  end;
end;

procedure PrintArr(arr: TArr_int);
var
  i: integer;
begin
  Write('[');

  for i := 1 to High(arr) do
    if i <> High(arr) then
      Write(arr[i], ', ')
    else
      WriteLn(arr[i], ']');
end;

procedure Main;
var
  s: integer;
begin
  Init;
  PrintGraph;
  DrawLineBlockEnd;

  s := 5;

  Init;
  WriteLn('Dijkstra_While:');
  Dijkstra_While(s);
  PrintArr(dist);
  PrintArr(path);
  FindPath(s);
  DrawLineBlockEnd;

  Init;
  WriteLn('Dijkstra_For:');
  Dijkstra_For(s);
  PrintArr(dist);
  PrintArr(path);
  FindPath(s);
  DrawLineBlockEnd;
end;

{ TPair }

constructor TPair.Create(newV, newWeight: integer);
begin
  Self.V := newV;
  Self.Weight := newWeight;
end;

class function TPair.Comparer(constref a, b: TPair): integer;
begin
  Result := a.Weight - b.Weight;
end;

end.
