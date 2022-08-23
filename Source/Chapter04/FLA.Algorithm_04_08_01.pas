unit FLA.Algorithm_04_08_01;

{$mode DelphiUnicode}

interface

uses
  Classes,
  SysUtils,
  DeepStar.Utils;

type
  TSolution = class(TObject)
  public const
    M = 10000 + 5;

  public type
    TArr_Double = array[0..M] of double;
    TArr2D_Integer = array[0..M, 0..M] of integer;
    TArr2D_Double = array[0..M, 0..M] of double;

  public
    c, w: TArr2D_Double;
    p, q: TArr_Double;
    s: TArr2D_Integer;
    n: integer;

    procedure Optimal_BST;
    procedure Construct_Optimal_BST(i, j: integer; flag: boolean);
  end;

procedure Main;

implementation

procedure Main;
var
  a, b: TArr_dbl;
  n, i: integer;
  TS: TSolution;
begin
  n := 6;
  a := [0.04, 0.09, 0.08, 0.02, 0.12, 0.14];
  b := [0.06, 0.08, 0.10, 0.07, 0.05, 0.05, 0.10];

  TS := TSolution.Create();
  try
    TS.n := n;
    for i := 1 to n do
      TS.p[i] := a[i - 1];
    for i := 0 to n do
      TS.q[i] := b[i];
    TS.Optimal_BST;
    writeLn('最小的搜索成本为：', TS.c[1, n].ToString);
    Write('最优二叉搜索树为：');
    TS.Construct_Optimal_BST(1, n, false);
  finally
    TS.Free;
  end;
end;

{ TSolution }

procedure TSolution.Construct_Optimal_BST(i, j: integer; flag: boolean);
var
  k: integer;
begin
  if flag = false then
  begin
    writeLn('S', s[i, j], ' 是根');
    flag := true;
  end;
  k := s[i, j];
  if k - 1 < i then
    writeLn('e', k - 1, ' is the left child of ', 'S', k)
  else
  begin
    writeLn('S', s[i, k - 1], ' is the left child of ', 'S', k);
    Construct_Optimal_BST(i, k - 1, true);
  end;
  if k >= j then
    writeLn('e', j, ' is the right child of ', 'S', k)
  else
  begin
    writeLn('S', s[k + 1, j], ' is the right child of ', 'S', k);
    Construct_Optimal_BST(k + 1, j, true);
  end;
end;

procedure TSolution.Optimal_BST;
var
  i, t, j, k, i1, j1: integer;
  temp: double;
begin
  for i := 1 to n + 1 do
  begin
    c[i, i - 1] := 0.0;
    w[i, i - 1] := q[i - 1];
  end;

  for t := 1 to n do
  begin
    for i := 1 to n - t + 1 do
    begin
      j := i + t - 1;
      w[i, j] := w[i, j - 1] + p[j] + q[j];
      if s[i, j - 1] > i then i1 := s[i, j - 1] else i1 := i;
      if s[i + 1, j] < j then j1 := s[i + 1, j] else j1 := j;

      c[i, j] := c[i, i1 - 1] + c[i1 + 1, j];
      s[i, j] := i1;

      for k := i1 + 1 to j1 do
      begin
        temp := c[i, k - 1] + c[k + 1, j];
        if (temp < c[i, j]) and (Abs(temp - c[i, j]) > 1E-6) then
        begin
          c[i, j] := temp;
          s[i, j] := k;
        end;
      end;
    end;
    c[i, j] += w[i, j];
  end;
end;

end.
