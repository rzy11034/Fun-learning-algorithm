unit FLA.Algorithm_01_14;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  SysUtils,
  DeepStar.Utils;

procedure Main;

implementation

function Prime(n: integer): boolean;
var
  i: integer;
begin
  if n <= 1 then Exit(false);
  if n = 2 then Exit(true);

  i := 2;
  while i <= Sqrt(n) do
  begin
    if n mod i = 0 then
      Exit(false);

    i += 1;
  end;

  Result := true;
end;

procedure Main;
var
  i, n: integer;
begin
  i := 4;
  while i <= 100 do
  begin
    for n := 2 to i - 1 do
    begin
      if Prime(n) then
      begin
        if Prime(i - n) then
        begin
          WriteLnF('%d=%d+%d', [i, n, i - n]);
        end;
      end;

      if i = n then WriteLn('error');
    end;

    i += 2;
  end;
end;

end.
