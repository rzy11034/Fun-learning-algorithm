unit FLA.Algorithm_02_04;

{$mode ObjFPC}{$H+}{$J-}
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
  TArrayUtils_int.SetLengthAndFill(dist, N);
  TArrayUtils_int.SetLengthAndFill(path, N);
  TArrayUtils_int.SetLengthAndFill(map, N, N);
  TArrayUtils_bool.SetLengthAndFill(visited, N);

  for i := 0 to High(map) do
  begin
    dist[i] := MaxInt;

    for j := 0 to High(map) do
      map[i, j] := MaxInt;

    visited[i] := false;
    path[i] := -1;
  end;

  for i := 0 to High(EDGES) do
  begin
    v1 := EDGES[i].V1 - 1;
    v2 := EDGES[i].V2 - 1;

    map[v1, v2] := Min(map[v1, v2], EDGES[i].Weight);
  end;
end;

procedure Dijkstra(v: integer);
var
  i, j, curDis, curIndex: integer;
begin
  for i := 0 to N - 1 do
  begin
    dist[i] := MaxInt;
    visited[i] := false;

    if dist[i] = MaxInt then
      path[i] := -1
    else
      path[i] := v;
  end;

  dist[v] := 0;
  curIndex := -1;

  while true do
  begin
    curDis := MaxInt;

    for i := 0 to High(map[v]) do
    begin
      if (not visited[i]) and (map[v, i] < curDis) then
      begin
        curDis := map[v, i];
        curIndex := i;
      end;
    end;

    if curDis = MaxInt then Break;

    visited[curIndex] := true;
    for j := 0 to High(map[curIndex]) do
    begin
      if (curDis < map[curIndex, j] + dist[curIndex]) then
      begin
        dist[j] := dist[curIndex] + map[curIndex, j];
        path[j] := curIndex;
      end;
    end;
  end;
end;

procedure PrintGraph;
var
  i, j, m: integer;
begin
  for i := 0 to High(map) do
  begin
    for j := 0 to High(map[i]) do
    begin
      m := specialize IfThen<integer>(map[i, j] = MaxInt, 0, map[i, j]);
      WriteF('%4d', [m]);
    end;

    WriteLn;
  end;
end;

procedure Main;
type
  TArrayUtils_int64 = specialize TArrayUtils<int64>;
var
  i: integer;
  a: TArr_int;
begin
  Init;
  PrintGraph;
  Dijkstra(0);
  TArrayUtils_int.Print(dist);
end;

end.
