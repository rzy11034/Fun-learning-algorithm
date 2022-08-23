unit FLA.Algorithm_05_01;

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

var
  i, j, n, Weight: integer;
  w, v: TArr_Double;
  x, bestx: TArr_Boolean;
  cw, cp, bestp: double;

function Bound(i: integer): double;
var
  rp: integer;
begin
  rp := 0;
  while i <= n do
  begin
    rp += round(v[i]);
    i += 1;
  end;

  Result := cp + rp;
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
begin
  cw := 0;
  cp := 0;
  sumw := 0.0;
  sumv := 0.0;

  for i := 1 to n do
  begin
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

end.
