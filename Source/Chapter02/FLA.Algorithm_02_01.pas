unit FLA.Algorithm_02_01;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  DeepStar.Utils;

procedure Main;

implementation

procedure Main;
var
  w: array of double;
  n, i, ans: integer;
  c, temp: double;
begin
  c := 30;
  n := 8;
  temp := 0;
  ans := 0;

  WriteLn('请输入载重量c和古董数量n:');
  ReadLn(c, n);

  //w := [4, 10, 7, 11, 3, 5, 14, 2];

  SetLength(w, n);
  WriteLn('请输入每个古董的重量，用空格分开：');
  // 4 10 7 11 3 5 14 2
  for i := 0 to n - 1 do
  begin
    Read(w[i]);
  end;

  ReadLn;

  TArrayUtils_dbl.Sort(w);

  for i := 0 to High(w) do
  begin
    temp += w[i];

    if temp <= c then
    begin
      ans += 1;
    end
    else
      Break;
  end;

  WriteLn(ans);
end;


end.
