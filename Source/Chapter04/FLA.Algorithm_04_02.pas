unit FLA.Algorithm_04_02;

{$mode DelphiUnicode}

interface

uses
  Classes,
  SysUtils,
  Math,
  DeepStar.Utils,
  DeepStar.UString;

procedure Main;

implementation

type
  TEditDistance_Examples = class(TObject)
  public
    d: TArr2D_int;
    str1, str2: string;

    function EditDistance(str1, str2: string): integer;
  end;

procedure Main;
var
  o: TObject;
begin
  o := TEditDistance_Examples.Create;
  with o as TEditDistance_Examples do
  begin
    str1 := 'family';
    str2 := 'frame';
    WriteLn(EditDistance(str1, str2));

    Free;
  end;
end;

{ TEditDistance_Examples }

function TEditDistance_Examples.EditDistance(str1, str2: string): integer;
var
  i, j, diff, temp: integer;
begin
  SetLength(d, str1.Length + 1, str2.Length + 1);
  for i := 0 to str1.Length do
    d[i, 0] := i;
  for i := 0 to str2.Length do
    d[0, i] := i;

  for i := 1 to str1.Length do
  begin
    for j := 1 to str2.Length do
    begin
      if str1.Chars[i - 1] = str2.Chars[j - 1] then
        diff := 0
      else
        diff := 1;

      temp := min(d[i - 1, j] + 1, d[i, j - 1] + 1);
      d[i, j] := min(temp, d[i - 1, j - 1] + diff);
    end;
  end;

  Result := d[str1.Length, str2.Length];
end;

end.
