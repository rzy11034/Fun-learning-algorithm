unit FLA.Algorithm_04_05;

{$mode DelphiUnicode}

interface

uses
  Classes,
  SysUtils,
  DeepStar.Utils;

procedure Main;

implementation

type
  TConvexPolygontrianGulation = class(TObject)
  public const Max = 1000 + 5;

  public
    n: integer;
    s: array[0..Max, 0..Max] of integer;
    m, g: array[0..Max, 0..Max] of double;

    procedure ConvexPolygontrianGulation;
    procedure Print(i, j: integer);
  end;

procedure Main;
var
  a: TArr2D_int;
  i, j: integer;
  o: TConvexPolygontrianGulation;
begin
  a := [
    [0, 2, 3, 1, 5, 6],
    [2, 0, 3, 4, 8, 6],
    [3, 3, 0, 10, 13, 7],
    [1, 4, 10, 0, 12, 5],
    [5, 8, 13, 12, 0, 3],
    [6, 6, 7, 5, 3, 0]];

  o := TConvexPolygontrianGulation.Create;
  with o do
  begin
    n := 6;
    n -= 1;

    for i := 0 to n do
      for j := 0 to n do
        g[i, j] := a[i, j];

    ConvexPolygontrianGulation;
    writeLn(m[1, n].ToString);
    Print(1, n);

    Free;
  end;
end;

{ TConvexPolygontrianGulation }

procedure TConvexPolygontrianGulation.ConvexPolygontrianGulation;
var
  i, d, j, k: integer;
  temp: double;
begin
  for i := 1 to n do
  begin
    m[i, i] := 0;
    s[i, i] := 0;
  end;

  for d := 2 to d do
  begin
    for i := 1 to n - d + 1 do
    begin
      j := i + d - 1;
      m[i, j] := m[i + 1, j] + g[i - 1, i] + g[i, j] + g[i - 1, j];
      s[i, j] := i;

      for k := i + 1 to j - 1 do
      begin
        temp := m[i, k] + m[k + 1, j] + g[i - 1, k] + g[k, j] + g[i - 1, j];
        if m[i, j] > temp then
        begin
          m[i, j] := temp;
          s[i, j] := k;
        end;
      end;
    end;
  end;
end;

procedure TConvexPolygontrianGulation.Print(i, j: integer);
begin
  if i = j then Exit;

  if s[i, j] > i then
    writeLn('{v', i - 1, ' v', s[i, j], '}');
  if j > s[i, j] + 1 then
    writeLn('{v', s[i, j], ' v', j, '}');

  Print(i, s[i, j]);
  Print(s[i, j] + 1, j);
end;

end.
