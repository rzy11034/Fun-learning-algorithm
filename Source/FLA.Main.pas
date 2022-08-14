unit FLA.Main;

{$mode delphiunicode}
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
  FLA.Algorithm_04_06_01, FLA.Algorithm_04_06;

procedure Test;
begin
  Exit;
end;

procedure Run;
begin
  Test;
  FLA.Algorithm_04_06.Main;
  DrawLineBlockEnd;
  FLA.Algorithm_04_06_01.Main
end;

end.
