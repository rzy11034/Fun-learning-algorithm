unit FLA.Algorithm_07_01;

{$mode objfpc}{$H+}
{$ModeSwitch unicodestrings}

interface

uses
  Classes,
  SysUtils,
  DeepStar.Utils,
  DeepStar.UString;

procedure Main;

implementation

var
  kernel: TArr2D_dbl;
  FJL: TArr_chr;
  JL: TArr_chr;
  n, m, i, j: integer;

procedure Init;
var
  n: integer;
begin
  n := 100;
  SetLength(kernel, n, n);
  SetLength(FJL, n);
  SetLength(JL, n);
end;

procedure Print;
begin
  WriteLn;
  WriteLn('----------单纯形表如下：----------');
  Write(' ');
  WriteF('%7s', ['b']);

  for i := 1 to n do
    WriteF('%8s%s', ['x', FJL[i]]);
  WriteLn;
  Write('c');

  for i := 0 to n do
  begin
    if i >= 1 then
      Write('x', JL[i]);
    for j := 0 to m do
      WriteF('%8s ', [kernel[i, j].ToString]);
    WriteLn;
  end;
end;

procedure DCXA();
var
  max1, max2, min, temp: double;
  e, k: integer;
begin
  e := -1;
  k := -1;

  while true do
  begin
    max1 := 0;
    max2 := 0;
    min := 100000000;

    for j := 1 to m do
    begin
      if max1 < kernel[0, j] then
      begin
        max1 := kernel[0, j];
        e := j;
      end;
    end;

    if max1 <= 0 then
    begin
      WriteLn;
      WriteLn('获得最优解：', kernel[0, 0]);
      Print();
      Break;
    end;

    for i := 1 to n do
    begin
      if max2 < kernel[i, e] then
        max2 := kernel[i, e];

      if kernel[i, e] <> 0 then
        temp := kernel[i, 0] / kernel[i, e]
      else
        temp := 0;

      if (temp > 0) and (temp < min) then
      begin
        min := temp;
        k := i;
      end;
    end;

    Write('基列变量:', 'x', FJL[e], ' ');
    WriteLn('离基变量：', 'x', JL[k]);

    if max2 = 0 then
    begin
      WriteLn('解无界');
      Break;
    end;

    //temp := FJL[e];
    //FJL[e] := JL[k];
    //JL[k] := temp;
    specialize Swap<char>(FJL[e], JL[k]);

    for i := 0 to n do
    begin
      if i <> k then
      begin
        for j := 0 to m do
        begin
          if j <> e then
          begin
            if (i = 0) and (j = 0) then
              kernel[i, j] := kernel[i, j] + kernel[i, e] * kernel[k, j] / kernel[k, e]
            else
              kernel[i, j] := kernel[i, j] + kernel[i, e] * kernel[k, j] / kernel[k, e];
          end;
        end;
      end;
    end;

    for i := 0 to n do
    begin
      if i <> k then
        kernel[i, e] := -kernel[i, e] / kernel[k, e];
    end;

    for j := 0 to m do
    begin
      if j <> e then
        kernel[k, j] := kernel[k, j] / kernel[k, e];
    end;

    kernel[k, e] := 1 / kernel[k, e];
    Print;
  end;
end;

procedure Main;
var
  a: TArr2D_dbl;
begin
  WriteLn('输入非基本变量个数和非基本变量下标：', #13#10 + '3', #13#10 + '245');
  m := 3;
  FJL := '0245'.ToCharArray;

  WriteLn('输入基本变量个数和基本变量下标：', #13#10 + '4', #13#10 + '1367');
  n := 4;
  JL := '01367'.ToCharArray;

  Init;
  WriteLn('输入约束标准型初始单纯形表参数：');
  a := [
    [0, 2.5, 2.8, 76.25],
    [0, 1, 0, -5],
    [0, 0, 1, -2],
    [12000, 0, 0, 1],
    [1000, 0.1, 0.08, 0.05]];
  for i := 0 to n do
    for j := 0 to m do
      kernel[i, j] := a[i, j];

  Print;
  DCXA;
end;

end.
