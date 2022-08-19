unit FLA.Algorithm_04_07;

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
    c: TArr2D;
    w, v, x: TArr;
    n, weight, Result: integer;

    constructor Create(n, weight: integer; const newWeight, newV: TArr_int);
  end;

procedure Main;

implementation

procedure Main;
var
  TS: TSolution;
  w, v: TArr_int;
  i: integer;
begin
  w := [2, 5, 4, 2, 3];
  v := [6, 3, 5, 4, 6];

  TS := TSolution.Create(5, 10, w, v);
  try
    WriteLnF('装入购物车的最大价值为：%d', [TS.Result]);
    Write('装入购物车的物品为：');
    for i := Low(TS.x) to High(TS.x) do
    begin
      if TS.x[i] = 1 then
      begin
        WriteF('%d ', [i]);
      end;
    end;

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

  for i := 1 to n do
  begin
    for j := 1 to weight do
    begin
      if j < w[i] then
        c[i, j] := c[i - 1, j]
      else
        c[i, j] := max(c[i - 1, j], c[i - 1, j - w[i]] + v[i]);
    end;
  end;

  // 逆向构造最优解
  for i := n downto 1 do
  begin
    if c[i, j] > c[i - 1, j] then
    begin
      x[i] := 1;
      j -= w[i];
    end;
  end;

  Self.Result := c[n, Weight];
end;

end.
