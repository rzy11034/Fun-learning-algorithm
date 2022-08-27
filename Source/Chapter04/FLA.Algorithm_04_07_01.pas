unit FLA.Algorithm_04_07_01;

{$mode delphi}{$H+}
{$ModeSwitch unicodestrings}

interface

uses
  Classes,
  SysUtils,
  Math,
  DeepStar.Utils;

type
  TSolution = class(TObject)
  public const
    maxn = 10005;
    M = 205;

  public type
    TArr = array[0..M] of integer;
    TArr2D = array[0..M, 0..maxn] of integer;

  public
    dp: array[0..maxn] of integer;
    w, v, x: TArr;
    n, weight, Result: integer;

    constructor Create(n, weight: integer; const newWeight, newV: TArr_int);
    procedure opt1;
    procedure opt2;
    procedure opt3;
  end;

procedure Main;

implementation

procedure Main;
var
  TS: TSolution;
  w, v: TArr_int;
  n, weight, i: integer;
begin
  n := 5;
  weight := 10;
  w := [2, 5, 4, 2, 3];
  v := [6, 3, 5, 4, 6];

  TS := TSolution.Create(n, weight, w, v);
  try
    WriteLnF('装入购物车的最大价值为：%d', [TS.Result]);

    for i := 1 to weight do
    begin
      Write(TS.dp[i], ' ');
    end;

    WriteLn
  finally
    TS.Free;
  end;
end;

{ TSolution }

constructor TSolution.Create(n, weight: integer; const newWeight, newV: TArr_int);
var
  i: integer;
begin
  Self.n := n;
  Self.weight := weight;

  for i := 0 to High(newV) do
  begin
    Self.w[i + 1] := newWeight[i];
    Self.v[i + 1] := newV[i];
  end;

  //opt1;
  //opt2;
  opt3;

  Self.Result := dp[weight];
end;

procedure TSolution.opt1;
var
  i, j: integer;
begin
  for i := 1 to n do
  begin
    for j := weight downto 0 do
    begin
      if j >= w[i] then
        dp[j] := max(dp[j], dp[j - w[i]] + v[i]);
    end;
  end;
end;

procedure TSolution.opt2;
var
  i, j: integer;
begin
  for i := 1 to n do
    for j := weight downto w[i] do
      dp[j] := max(dp[j], dp[j - w[i]] + v[i]);
end;

procedure TSolution.opt3;
var
  sum: TArr;
  bound, i, j: integer;
begin
  sum[0] := 0;
  for i := 1 to n do
    sum[i] := sum[i - 1] + w[i];
  for i := 1 to n do
  begin
    bound := max(w[i], weight - (sum[n] - sum[i - 1]));
    for j := weight downto bound do
      dp[j] := max(dp[j], dp[j - w[i]] + v[i]);
  end;
end;

end.
