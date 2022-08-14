unit FLA.Main;

{$mode delphiunicode}

interface

uses
  Classes,
  SysUtils,
  {%H-}Math,
  {%H-}DeepStar.DSA.Interfaces,
  {%H-}DeepStar.Math,
  {%H-}DeepStar.Utils,
  {%H-}DeepStar.UString;

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
