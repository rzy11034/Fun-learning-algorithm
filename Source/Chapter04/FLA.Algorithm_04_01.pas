unit FLA.Algorithm_04_01;

{$mode objfpc}{$H+}
{$ModeSwitch unicodestrings}

interface

uses
  Classes,
  SysUtils,
  DeepStar.UString,
  DeepStar.Utils;

procedure Main;

implementation

type
  TLCSL_Examples = class(TObject)
  private
    procedure __Print(i, j: integer);
  public
    c, b: TArr2D_int;
    s1, s2: string;
    procedure LCSL;
    procedure Print;
  end;

procedure Main;
var
  o: TObject;
begin
  o := TLCSL_Examples.Create;
  with (o as TLCSL_Examples) do
  begin
    s1 := 'ABCADAB';
    s2 := 'BACDBA';
    LCSL;
    Print;
    Free;
  end;
end;

{ TLCSL_Examples }

procedure TLCSL_Examples.LCSL;
var
  i, j: integer;
begin
  SetLength(c, S1.Length + 5, S2.Length + 5);
  SetLength(b, S1.Length + 1, S2.Length + 1);

  for i := 1 to s1.Length do
  begin
    for j := 1 to s2.Length do
    begin
      // 如果当前字符相同，内公共子序列的长度为该字符的最长公共序列 +1;
      if s1.Chars[i - 1] = s2.Chars[j - 1] then
      begin
        c[i, j] := c[i - 1, j - 1] + 1;
        b[i, j] := 1;
      end
      else
      begin
        // 两者找最大值, 并记录最优策略来源
        if c[i, j - 1] >= c[i - 1, j] then
        begin
          c[i, j] := c[i, j - 1];
          b[i, j] := 2;
        end
        else
        begin
          c[i, j] := c[i - 1, j];
          b[i, j] := 3;
        end;
      end;
    end;
  end;
end;

procedure TLCSL_Examples.Print;
begin
  __Print(s1.Length, s2.Length);
end;

procedure TLCSL_Examples.__Print(i, j: integer);
begin
  if (i = 0) or (j = 0) then Exit;

  if b[i, j] = 1 then
  begin
    __Print(i - 1, j - 1);
    Write(s1.Chars[i - 1]);
  end
  else
  begin
    if b[i, j] = 2 then
      __Print(i, j - 1)
    else
      __Print(i - 1, j);
  end;
end;

end.
