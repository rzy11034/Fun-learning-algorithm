unit FLA.Algorithm_05_06;

{$mode objfpc}{$H+}
{$ModeSwitch unicodestrings}

interface

uses
  Classes,
  SysUtils,
  DeepStar.Utils;

procedure Main;

implementation

const
  INF = 1E7;
  _N_ = 100;

type
  TArr2D_Integer = array[0.._N_, 0.._N_] of integer;
  TArr_Integer = array [0.._N_] of integer;

var
  g: TArr2D_Integer;
  x, bestx: TArr_Integer;
  cl, bestl, n, m: integer;

procedure Traveling(t: integer);
var
  j: integer;
begin
  if t > n then
  begin
    if (g[x[n], 1] <> INF) and (cl + g[x[n], 1] < bestl) then
    begin
      for j := 1 to n do
        bestx[j] := x[j];
      bestl := cl + g[x[n], 1];
    end;
  end
  else
  begin
    for j := t to n do
    begin
      if (g[x[t - 1], x[j]] <> INF) and (cl + g[x[t - 1], x[j]] < bestl) then
      begin
        specialize Swap<integer>(x[t], x[j]);
        cl := cl + g[x[t - 1], x[t]];
        Traveling(t + 1);
        cl := cl - g[x[t - 1], x[t]];
        specialize Swap<integer>(x[t], x[j]);
      end;
    end;
  end;
end;

procedure Init;
var
  i, j: integer;
begin
  bestl := trunc(INF);
  cl := 0;
  for i := 1 to n do
  begin
    for j := i to n do
    begin
      g[i, j] := trunc(INF);
      g[j, i] := trunc(INF);
    end;
  end;

  for i := 1 to n do
  begin
    x[i] := i;
    bestx[i] := 0;
  end;
end;

procedure Print;
var
  i: integer;
begin
  Write('最短路径：');
  for i := 1 to n do
    Write(bestx[i], '--->');
  WriteLn('1');
  WriteLn('最短路径长度：', bestl);
end;

procedure Main;
var
  u, v, w: TArr_int;
  i: integer;
begin
  n := 5;
  m := 9;
  u := [1, 1, 1, 2, 2, 2, 3, 3, 4];
  v := [2, 4, 5, 3, 4, 5, 4, 5, 5];
  w := [3, 8, 9, 3, 10, 5, 4, 3, 20];

  Init;

  for i := 0 to m - 1 do
  begin
    g[u[i], v[i]] := w[i];
    g[v[i], u[i]] := w[i];
  end;

  Traveling(2);
  Print;
end;

end.
