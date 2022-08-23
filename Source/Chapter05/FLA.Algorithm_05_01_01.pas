unit FLA.Algorithm_05_01_01;

{$mode DelphiUnicode}

interface

uses
  Classes,
  SysUtils,
  DeepStar.Utils;

procedure Main;

implementation

const
  M = 105;

type
  TArr_Double = array[0..M] of double;
  TArr_Boolean = array[0..M] of boolean;

  TNode = record
    id: integer;
    d: double;
    class function cmp(constref a, b: TNode): integer; static;
  end;

var
  i, j, n, Weight: integer;
  w, v: TArr_Double;
  x, bestx: TArr_Boolean;
  cw, cp, bestp: double;

function Bound(i: integer): double;
var
  cleft, brp: double;
begin
  cleft := Weight - cw;
  brp := 0.0;

  while (i <= n) and (w[i] < cleft) do
  begin
    cleft -= w[i];
    brp += v[i];
    i += 1;
  end;

  if i <= n then
    brp += v[i] / w[i] * cleft;

  Result := cp + brp;
end;

procedure Backtrack(t: integer);
begin
  if t > n then
  begin
    for j := 1 to n do
      bestx[j] := x[j];
    bestp := cp;
    Exit;
  end;

  if cw + w[t] <= Weight then
  begin
    x[t] := true;
    cw += w[t];
    cp += v[t];
    Backtrack(t + 1);
    cw -= w[t];
    cp -= v[t];
  end;

  if Bound(t + 1) > bestp then
  begin
    x[t] := false;
    Backtrack(t + 1);
  end;
end;

procedure Knapsack(Weight: double; n: integer);
var
  sumw, sumv: double;
  Q: array of TNode;
  a, b: array of double;
begin
  cw := 0;
  cp := 0;
  sumw := 0.0;
  sumv := 0.0;
  SetLength(Q, n);
  SetLength(a, n + 1);
  SetLength(b, n + 1);

  for i := 1 to n do
  begin
    Q[i - 1].id := i;
    Q[i - 1].d := 1.0 * v[i] / w[i];
    sumv += w[i];
    sumw += w[i];
  end;

  if sumw <= Weight then
  begin
    bestp := sumv;
    writeLn('放入购物车的物品最大价值为：', bestp.ToString);
    Write('所有的物品均放入购物车。');
    Exit;
  end;

  TArrayUtils<TNode>.Sort(Q, @TNode.cmp);
  for i := 1 to n do
  begin
    a[i] := w[Q[i - 1].id];
    b[i] := v[Q[i - 1].id];
  end;

  for i := 1 to n do
  begin
    w[i] := a[i];
    v[i] := b[i];
  end;

  Backtrack(1);
  writeLn('放入购物车的物品最大价值为：', bestp.ToString);
  Write('放入购物车的物品序号为：');
  for i := 1 to n do
    if bestx[i] = true then
      Write(i, ' ');

  writeLn;
end;

procedure Main;
var
  a, b: TArr_int;
begin
  n := 4;
  Weight := 10;
  a := [2, 5, 4, 2];
  b := [6, 3, 5, 4];

  for i := 1 to n do
  begin
    w[i] := a[i - 1];
    v[i] := b[i - 1];
  end;

  Knapsack(Weight, n);
end;

{ TNode }

class function TNode.cmp(constref a, b: TNode): integer;
var
  res: integer;
begin
  if a.d > b.d then
    res := 1
  else if a.d < b.d then
    res := -1
  else
    res := 0;

  Result := res;
end;

end.
