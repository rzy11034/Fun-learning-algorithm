unit FLA.Algorithm_04_04;

{$mode DelphiUnicode}

interface

uses
  Classes,
  SysUtils,
  DeepStar.Utils;

procedure Main;

implementation

type
  TMatrixChain = class(TObject)
  public const msize = 100;

  public
    p: array[0..msize] of integer;
    m, s: array[0..msize, 0..msize] of integer;
    n: integer;

    procedure MatrixChain;
    procedure Print(i, j: integer);
  end;

procedure Main;
var
  a: TArr_int;
  i: integer;
begin
  a := [3, 5, 10, 8, 2, 4];

  with TMatrixChain.Create do
  begin
    n := 5;
    for i := 0 to n do
      p[i] := a[i];

    MatrixChain;
    Print(1, n);
    writeLn('最小计算量的值为：', m[1, n]);
    Free;
  end;
end;

{ TMatrixChain }

procedure TMatrixChain.MatrixChain;
var
  i, j, r, k, t: integer;
begin
  for r := 2 to n do
  begin
    for i := 1 to n - r + 1 do
    begin
      j := i + r - 1;
      m[i, j] := m[i + 1, j] + p[i - 1] * p[i] * p[j];
      s[i, j] := i;

      for k := i + 1 to j - 1 do
      begin
        t := m[i, k] + m[k + 1, j] + p[i - 1] * p[k] * p[j];
        if t < m[i, j] then
        begin
          m[i, j] := t;
          s[i, j] := k;
        end;
      end;
    end;
  end;
end;

procedure TMatrixChain.Print(i, j: integer);
begin
  if i = j then
  begin
    Write('A[', i, ']');
    Exit;
  end;

  Write('(');
  Print(i, s[i, j]);
  Print(s[i, j] + 1, j);
  Write(')');
end;

end.
