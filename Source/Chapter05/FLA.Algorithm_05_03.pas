unit FLA.Algorithm_05_03;

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
  MX = 50;

type
  TArr_Integer = array[0..MX] of integer;
  TArr2D_Integer = array[0..MX, 0..MX] of integer;

var
  x: TArr_Integer;
  map: TArr2D_Integer;
  sum, n, m, edge: integer;

procedure CreateMap;
var
  u, v: TArr_int;
  k, i, j: integer;
begin
  u := [1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6];
  v := [2, 3, 4, 3, 5, 4, 5, 5, 7, 6, 7, 7];

  for k := 0 to edge - 1 do
  begin
    i := u[k];
    j := v[k];
    map[i, j] := 1;
    map[j, i] := 1;
  end;
end;

function OK(t: integer): boolean;
var
  j: integer;
begin
  for j := 1 to t do
    if map[t, j] = 1 then
      if x[j] = x[t] then
        Exit(false);

  Result := true;
end;

procedure Backtrack(t: integer);
var
  i: integer;
begin
  if t > n then
  begin
    sum += 1;
    Write('第', sum, '种方案：');
    for i := 1 to n do
      Write(x[i], ' ');
    WriteLn;
  end
  else
  begin
    for i := 1 to m do
    begin
      x[t] := i;
      if OK(t) then
        Backtrack(t + 1);
    end;
  end;
end;

procedure Main;
begin
  n := 7;
  m := 3;
  edge := 12;

  CreateMap;
  Backtrack(1);
end;

end.
