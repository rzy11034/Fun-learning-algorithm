unit FLA.Algorithm_02_01;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  SysUtils,
  Rtti,
  DeepStar.Utils;

procedure Main;

implementation

procedure Main;
var
  w: array of extended;
  n, i: integer;
  c: double;
  Value: TValue;
  s: string;
begin
  w := [4, 10, 7, 11, 3, 5, 14, 2];
  //w := ['a','b'];
  //w := ['aa','bb'];
  //w := [true, false];

  for i := 0 to High(w) do
  begin
    Value := TValue.specialize From<extended>(w[i]);
    s := Value.ToString;
  end;


  //WriteLn('请输入载重量c和古董数量n:');
  //ReadLn(c, n);
  //
  //SetLength(w, n);
  //
  //WriteLn('请输入每个古董的重量，用空格分开：');
  //for i := 0 to n - 1 do
  //begin
  //  Read(w[i]);
  //end;


  //ReadLn;
end;

end.
