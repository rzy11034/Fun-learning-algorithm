unit FLA.Algorithm_02_04;

{$mode ObjFPC}{$H+}{$J-}
{$ModeSwitch advancedrecords}
{$ModeSwitch unicodestrings}

interface

uses
  Classes,
  SysUtils,
  Math,
  DeepStar.Utils,
  DeepStar.UString;

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
  M = 11; // 城市间路线的条数

  EDGES: array[1..M] of TEdge = (
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
  dist: array [1..N] of integer;
  map: array [1..N, 1..N] of integer;
  path: array [1..N] of integer;

  // 如果 flag[]等于 true，说明顶点土己经加入到集合s；
  // 否则顶点土属于集合 v-s
  flag: array[1..N] of boolean;


procedure Init;
var
  i, j, v1, v2: integer;
begin
  for i := 1 to N do
  begin
    dist[i] := MaxInt;

    for j := 1 to N do
      map[i, j] := MaxInt;

    flag[i] := false;
    path[i] := -1;
  end;

  for i := 1 to M do
  begin
    v1 := EDGES[i].V1;
    v2 := EDGES[i].V2;

    map[v1, v2] := Min(map[v1, v2], EDGES[i].Weight);
  end;
end;

procedure Dijkstra(u: integer);
var
  i, j, dest, t: integer;
begin
  for i := 1 to N do
  begin
    dist[i] := map[u, i];
    flag[i] := false;

    if dist[i] = MaxInt then
      path[i] := -1
    else
      path[i] := u;
  end;

  dist[u] := 0;
  flag[u] := true;

  for i := 1 to N do
  begin
    dest := 0;
    t := 0;

    if (flag[i] <> true) and (map[u, i] < MaxInt) then
    begin
      dest := map[u, i];
      t := i;
    end;
  end;
end;

procedure PrintGraph;
var
  i, j, m: integer;
begin
  for i := 1 to N do
  begin
    for j := 1 to N do
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
  aa: array of int64;
begin
  Init;
  PrintGraph;

  TArrayUtils_int64.SetLengthAndFill(aa, 20);

  Dijkstra(1);
end;

end.
