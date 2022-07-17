unit FLA.Main;

{$mode ObjFPC}{$H+}
{$ModeSwitch unicodestrings}

interface

uses
  Classes,
  SysUtils,
  {%H-}Math,
  {%H-}DeepStar.Utils;

procedure Run;

implementation

uses
  FLA.Algorithm_02_04;

procedure Run;
var
  i:integer;
begin
  i := 4;

  i := i >> 1;

  WriteLn(i);

  Main;
end;

end.
