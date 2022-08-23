unit FLA.Algorithm_05_05;

{$mode DelphiUnicode}

interface

uses
  Classes,
  SysUtils,
  Math,
  DeepStar.Utils;

procedure Main;

implementation

const
  INF = $3F3F3F3F;
  MX = 10000 + 5;

type
  TNode = record
    x, y: integer;
  end;

  TArr_Integer = array[0..MX] of integer;
  TArr_TNode = array[0..MX] of TNode;

var
  nodes: TArr_TNode;
  x, bestx: TArr_Integer;
  n, bestf, f1, f2: integer;

procedure Backtrack(t: integer);
var
  i, temp: integer;
begin
  if t > n then
  begin
    for i := 1 to n do
      bestx[i] := x[i];

    bestf := f2;
    Exit;
  end;

  for i := t to n do
  begin
    f1 += nodes[x[i]].x;
    temp := f2;
    f2 := max(f2, f1) + nodes[x[i]].y;
    if f2 < bestf then
    begin
      Swap<integer>(x[t], x[i]);
      Backtrack(t + 1);
      Swap<integer>(x[t], x[i]);
    end;

    f1 -= nodes[x[i]].x;
    f2 := temp;
  end;
end;

procedure Main;
var
  a, b: TArr_int;
  i: integer;
begin
  n := 6;
  a := [5, 1, 8, 5, 3, 4];
  b := [7, 2, 2, 4, 7, 4];

  for i := 1 to n do
  begin
    nodes[i].x := a[i - 1];
    nodes[i].y := b[i - 1];
    x[i] := i;
  end;

  bestf := INF;
  f1 := 0;
  f2 := 0;

  Backtrack(1);
  Write('最优的机器零件加工顺序为：');
  for i := 1 to n do
    Write(bestx[i], ' ');
  WriteLn;
  Write('最优的机器零件加工的时间为：');
  WriteLn(bestf);
end;

end.
