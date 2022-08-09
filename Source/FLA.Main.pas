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

procedure sw(a: TArr);
begin
  a[0] := 1;
end;

procedure Test;
var
  a: TArr;
begin
  SetLength(a, 10);
  sw(a);
  Exit;
end;

procedure Run;
begin
  Test;
  Main;
end;

end.
