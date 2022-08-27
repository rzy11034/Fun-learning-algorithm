unit FLA.Algorithm_05_05_02;

{$mode objfpc}{$H+}
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
  TNode = record
    id, x, y: integer;
  end;

  TArr_TNode = array of TNode;

var
  nodes: TArr_TNode;
  n: integer;

function cmp(constref a, b: TNode): integer;
var
  res: integer;
begin
  if min(b.x, a.y) >= min(b.y, a.x) then
    res := 0
  else if min(b.x, a.y) < min(b.y, a.x) then
    res := -1;
  //else
  //  res := 0;

  Result := res;
end;

procedure Main;
var
  a, b: TArr_int;
  i, f1, f2: integer;
begin
  //n := 7;
  //a := [3, 8, 10, 12, 6, 9, 15];
  //b := [7, 2, 6, 18, 3, 10, 4];

  n := 6;
  a := [5, 1, 8, 5, 3, 4];
  b := [7, 2, 2, 4, 7, 4];
  SetLength(nodes, n);

  for i := 0 to n - 1 do
  begin
    nodes[i].x := a[i];
    nodes[i].y := b[i];
    nodes[i].id := i + 1;
  end;

  specialize TArrayUtils<TNode>.Sort(nodes, @cmp);

  f1 := 0;
  f2 := 0;
  for i := 0 to n - 1 do
  begin
    f1 += nodes[i].x;
    f2 := max(f1, f2) + nodes[i].y;
  end;

  Write('最优的机器零件加工顺序为：');
  for i := 0 to n - 1 do
    Write(nodes[i].id, ' ');
  WriteLn;
  Write('最优的机器零件加工的时间为：');
  WriteLn(f2);
end;

end.
