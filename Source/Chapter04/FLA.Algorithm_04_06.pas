unit FLA.Algorithm_04_06;

{$mode DelphiUnicode}

interface

uses
  Classes,
  SysUtils,
  Math,
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
    mins, maxs: TArr2D;
    sum, a: TArr;
    min_Circular, max_Circular: integer;

    procedure Straight(var a: TArr; n: integer);
    procedure Circular(var a: TArr; n: integer);
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
      a[i] := arr[i];

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

procedure TSolution.Circular(var a: TArr; n: integer);
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
    begin
      min_Circular := mins[i, n + i - 1];
      if maxs[i, n + i - 1] > max_Circular then
        max_Circular := maxs[i, n + i - 1];
    end;
  end;
end;

procedure TSolution.Straight(var a: TArr; n: integer);
var
  i, v, j, temp, k: integer;
begin
  for i := 1 to n do // 初始化
  begin
    mins[i, i] := 0;
    maxs[i, i] := 0;
  end;
  sum[0] := 0;
  for i := 1 to n do
    sum[i] := sum[i - 1] + a[i];

  for v := 2 to n do
  begin
    for i := 1 to n - v + 1 do
    begin
      j := i + v - 1;
      mins[i, j] := INF;
      maxs[i, j] := -1;
      temp := sum[j] - sum[i - 1];
      for k := i to j - 1 do
      begin
        mins[i, j] := min(mins[i, j], mins[i, k] + mins[k + 1, j] + temp);
        maxs[i, j] := max(maxs[i, j], maxs[i, k] + maxs[k + 1, j] + temp);
      end;
    end;
  end;
end;

end.
