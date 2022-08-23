unit FLA.Algorithm_05_02;

{$mode DelphiUnicode}

interface

uses
  Classes,
  SysUtils,
  DeepStar.Utils;

procedure Main;

implementation

const
  _N_ = 100;

type
  TArr2D_Integer = array[0.._N_, 0.._N_] of integer;
  TArr_Boolean = array[0.._N_] of boolean;

var
  a: TArr2D_Integer;
  x, bestx: TArr_Boolean;
  bestn, cn, n, m: integer;

function Place(t: integer): boolean;
var
  ok: boolean;
  j: integer;
begin
  ok := true;
  for j := 1 to t - 1 do
  begin
    if x[j] and (a[t, j] = 0) then
    begin
      ok := false;
      Break;
    end;
  end;

  Result := ok;
end;

procedure Backtrack(t: integer);
var
  i: integer;
begin
  if t > n then
  begin
    for i := 1 to n do
      bestx[i] := x[i];

    bestn := cn;
    Exit;
  end;

  if Place(t) then
  begin
    x[t] := true;
    cn += 1;
    Backtrack(t + 1);
    cn -= 1;
  end;

  if cn + n - t > bestn then
  begin
    x[t] := false;
    Backtrack(t + 1);
  end;
end;

procedure Main;
var
  u, v: TArr_int;
  k, i, j: integer;
begin
  n := 5;
  m := 8;
  u := [1, 1, 1, 1, 2, 3, 3, 4];
  v := [2, 3, 4, 5, 3, 4, 5, 5];

  for k := 0 to m - 1 do
  begin
    i := u[k];
    j := v[k];
    a[i, j] := 1;
    a[j, i] := 1;
  end;

  bestn := 0;
  cn := 0;
  Backtrack(1);
  WriteLn('国王护卫队的最大人数为：', bestn);
  Write('国王护卫队的成员为：');
  for i := 1 to n do
    if bestx[i] then
      Write(i, ' ');

  WriteLn;
end;

end.
