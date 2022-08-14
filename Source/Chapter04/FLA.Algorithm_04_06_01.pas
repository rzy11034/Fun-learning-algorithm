unit FLA.Algorithm_04_06_01;

{$mode DelphiUnicode}

interface

uses
  Classes,
  SysUtils,
  DeepStar.Utils;

procedure Main;

implementation

type
  TSolution = class(TObject)
  public const
    INF = 1 << 30;
    M = 205;

  public type
    TArr = array[0..M] of integer;
    TArr2D = array[0..M, 0..M] of integer;

  public
    mins, maxs, s: TArr2D;
    sum, a: TArr;
    min_Circular, max_Circular: integer;

    procedure Straight(a: TArr; n: integer);
    procedure Circular(a: TArr; n: integer);
    procedure Get_Min(n: integer);
    procedure Get_Max(n: integer);
  end;

procedure Main;
var
  t: TSolution;
  n, i: integer;
  arr: TArr_int;
begin
  n := 6;
  arr := [5, 8, 6, 9, 2, 3];

  t := TSolution.Create;
  with t do
  begin
    for i := 0 to High(arr) do
      a[i + 1] := arr[i];

    Straight(a, n);
    Write('路边玩法（直线型）最小花费为：', mins[1, n], #10);
    Write('路边玩法（直线型）最大花费为：', maxs[1, n], #10);

    Circular(a, n);
    Write('操场玩法（圆型）最小花费为：', min_Circular, #10);
    Write('操场玩法（圆型）最大花费为：', max_Circular, #10);
    Free;
  end;
end;

{ TSolution }

procedure TSolution.Circular(a: TArr; n: integer);
var
  i: integer;
begin
  for i := 1 to n - 1 do
    a[n + i] := a[i];
  n := 2 * n - 1;
  Straight(a, n);
  n := (n + 1) div 2;
  min_Circular := mins[1, n];
  max_Circular := maxs[1, n];
  for i := 2 to n do
  begin
    if mins[i, n + i - 1] < min_Circular then
      min_Circular := mins[i, n + i - 1];
    if maxs[i, n + i - 1] > max_Circular then
      max_Circular := maxs[i, n + i - 1];
  end;
end;

procedure TSolution.Get_Max(n: integer);
var
  v, i, j, temp: integer;
begin
  for v := 2 to n do
  begin
    for i := 1 to n - v + 1 do
    begin
      j := i + v - 1;
      maxs[i, j] := -1;
      temp := sum[j] - sum[i - 1];
      if maxs[i + 1, j] > maxs[i, j - 1] then
        maxs[i, j] := maxs[i + 1, j] + temp
      else
        maxs[i, j] := maxs[i, j - 1] + temp;
    end;
  end;
end;

procedure TSolution.Get_Min(n: integer);
var
  v, i, j, temp, i1, j1, k: integer;
begin
  for v := 2 to n do
  begin
    for i := 1 to n - v + 1 do
    begin
      j := i + v - 1;
      temp := sum[j] - sum[i - 1];
      if s[i, j - 1] > i then i1 := s[i, j - 1] else i1 := i;
      if s[i + 1, j] < j then j1 := s[i + 1, j] else j1 := j;
      mins[i, j] := mins[i, i1] + mins[i1 + 1, j];
      s[i, j] := i1;
      for k := i1 + 1 to j1 do
      begin
        if mins[i, k] + mins[k + 1, j] < mins[i, j] then
        begin
          mins[i, j] := mins[i, k] + mins[k + 1, j];
          s[i, j] := k;
        end;
      end;
      mins[i, j] += temp;
    end;
  end;
end;

procedure TSolution.Straight(a: TArr; n: integer);
var
  i: integer;
begin
  for i := 1 to n do
  begin
    mins[i, i] := 0;
    maxs[i, i] := 0;
    s[i, i] := 0;
  end;
  sum[0] := 0;
  for i := 1 to n do
    sum[i] := sum[i - 1] + a[i];
  Get_Min(n);
  Get_Max(n);
end;

end.
