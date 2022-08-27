unit FLA.Main;

{$mode objfpc}{$H+}
{$ModeSwitch unicodestrings}

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
  FLA.Algorithm_06_01;

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
