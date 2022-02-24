unit FLA.Algorithm_01_11;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  SysUtils,
  DeepStar.Utils;

procedure Main;

implementation

procedure Main;
var
  x, y, z: integer;
  Count: integer = 0; //记录可行解的个数
begin
  WriteLn('Count  Men  Women  Children');
  WriteLn('.......................................');

  for x := 1 to 9 do
  begin
    y := 20 - 2 * x;
    z := 30 - y - x;

    if 3 * x + 2 * y + z = 50 then
    begin
      Count += 1;
      WriteLnF('%d  %4d  %4d  %4d  ', [Count, x, y, z]);
    end;
  end;
end;

end.
