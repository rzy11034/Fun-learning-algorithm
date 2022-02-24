unit FLA.Algorithm_01_12;

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
  n: integer;
begin
  n := 1;

  while not ((n mod 2 = 1) and (n mod 3 = 2) and (n mod 5 = 4)
      and (n mod 6 = 5) and (n mod 7 = 0)) do
    n += 1;

  WriteLnF('Count the stairs = %d', [n]);
end;

end.
