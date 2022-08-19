unit FLA.Algorithm_04_07_01;

{$mode DelphiUnicode}

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
    Write('装入购物车的物品为：');


    WriteLn
  finally
    TS.Free;
  end;
end;

{ TSolution }

constructor TSolution.Create(n, weight: integer; const newWeight, newV: TArr_int);
var
  i, j: integer;
begin
  Self.n := n;
  Self.weight := weight;

  for i := 0 to High(newV) do
  begin
    Self.w[i + 1] := newWeight[i];
    Self.v[i + 1] := newV[i];
  end;

  opt1;

  Self.Result := dp[weight];
end;

procedure TSolution.opt1;
var
  i, j: integer;
begin
  for i := 1 to n do
  begin
    for j := weight downto 1 do
    begin
      if j >= weight then
        dp[j] := max(dp[j], dp[j - w[i]] + v[i]);
    end;
  end;
end;

end.
