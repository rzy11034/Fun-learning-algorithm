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
  FLA.Algorithm_04_03;

procedure Test;
begin
  Exit;
end;

procedure Run;
begin
  Test;
  Main;
end;

end.
