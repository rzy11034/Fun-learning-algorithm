unit FLA.Algorithm_05_06_01;

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
  _M_ = 1 shl 13;
  INF = $3F3F3F3F;

var
  dp, g, path: TArr2D_Int;
  n, m, bestl, sx, S: integer;

procedure Init;
begin
  TArrayUtils_int.SetLengthAndFill(dp, _M_ + 2, 20, INF);
  TArrayUtils_int.SetLengthAndFill(path, _M_ + 2, 15);
  TArrayUtils_int.SetLengthAndFill(g, 15, 15, INF);
  bestl := INF;
end;

procedure Traveling;
var
  i, j, k: integer;
begin
  dp[1, 0] := 0;
  S := 1 shl n;

  for i := 0 to S - 1 do
  begin
    for j := 0 to n - 1 do
    begin
      if not (i and (1 shl j) <> 0) then
        Continue;

      for k := 0 to n - 1 do
      begin
        if (i and (1 shl k)) <> 0 then
          Continue;

        if (dp[i or (1 shl k), k]) > dp[i, j] + g[j, k] then
        begin
          dp[i or (1 shl k), k] := dp[i, j] + g[j, k];
          path[i or (1 shl k), k] := j;
        end;
      end;
    end;
  end;

  for i := 0 to n - 1 do
  begin
    if bestl > dp[S - 1, i] + g[i, 0] then
    begin
      bestl := dp[S - 1, i] + g[i, 0];
      sx := i;
    end;
  end;
end;

procedure Print(S, Value: integer);
var
  i: integer;
begin
  if not (S <> 0) then
    Exit;

  for i := 0 to n - 1 do
    if dp[S, i] = Value then
    begin
      Print(S xor (1 shl i), Value - g[i, path[S, i]]);
      Write(i + 1, '--->');
      Break;
    end;
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
    g[u[i] - 1, v[i] - 1] := w[i];
    g[v[i] - 1, u[i] - 1] := w[i];
  end;

  Traveling;
  Write('最短路径：');
  Print(S - 1, bestl - g[sx, 0]);
  WriteLn(1);
  WriteLn('最短路径长度：', bestl);
end;

end.
