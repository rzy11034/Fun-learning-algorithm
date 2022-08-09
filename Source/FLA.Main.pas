unit FLA.Main;

{$mode delphiunicode}{$j-}
{$WARN 5023 off : Unit "$1" not used in $2}

interface

uses
  Classes,
  SysUtils,
  Math,
  DeepStar.DSA.Interfaces,
  DeepStar.Math,
  DeepStar.Utils,
  DeepStar.UString;

procedure Run;

implementation

uses
  FLA.Algorithm_03_04;

type
  TArrayOfInteger = array[0..9] of integer;
  TArr = array of integer;

procedure sw(var a: TArrayOfInteger);
begin
  a[0] := 1;
end;

procedure Test;
var
  a: TArrayList_int;
  b: integer;
begin
  a := TArrayList_int.Create(0);
  a.Clear;
  //while true do
  //begin
  //  b := a.Count;
  //  a.AddLast( 1);
  //  a.Add(0, 2);
  //  a[0] := 1;
  //  a[1] := 1;
  //end;
  a.Free;
  Exit;
end;

procedure Run;
begin
  Test;
  Main;
end;

end.
