unit FLA.Algorithm_04_03;

{$mode delphi}{$H+}
{$ModeSwitch unicodestrings}

interface

uses
  Classes,
  SysUtils,
  DeepStar.Utils;

procedure Main;

implementation

type
  TRent_Examples = class(TObject)
  public
    r, m, s: TArr2D_int;
    n: integer;

    constructor Create(n: integer; arr: TArr_int);
    procedure Rent;
    procedure Print(i, j: integer);
  end;

procedure Main;
var
  o: TObject;
  a: TArr_int;
  n: integer;
begin
  a := [2, 6, 9, 15, 20, 3, 5, 11, 18, 3, 6, 12, 5, 8, 6];
  n := 6;

  o := TRent_Examples.Create(n, a);
  with o as TRent_Examples do
  begin
    Rent;
    WriteLn(m[1, n]);
    Write(1);
    Print(1, n);
    Free;
  end;

  WriteLn;
end;

{ TRent_Examples }

constructor TRent_Examples.Create(n: integer; arr: TArr_int);
var
  len, k, i, j: integer;
begin
  Self.n := n;

  len := n + 1;
  SetLength(r, len, len);
  SetLength(m, len, len);
  SetLength(s, len, len);

  k := 0;
  for i := 1 to n do
  begin
    for j := i + 1 to n do
    begin
      r[i, j] := arr[k];
      m[i, j] := r[i, j];
      k += 1;
    end;
  end;
end;

procedure TRent_Examples.Print(i, j: integer);
begin
  if s[i, j] = 0 then
  begin
    Write('--', j);
    Exit;
  end;

  Print(i, s[i, j]);
  Print(s[i, j], j);
end;

procedure TRent_Examples.Rent;
var
  i, j, k, d, temp: integer;
begin
  for d := 3 to n do
  begin
    for i := 1 to n - d + 1 do
    begin
      j := i + d - 1;
      for k := i + 1 to j - 1 do
      begin
        temp := m[i, k] + m[k, j];
        if temp < m[i, j] then
        begin
          m[i, j] := temp;
          s[i, j] := k;
        end;
      end;
    end;
  end;
end;

end.
