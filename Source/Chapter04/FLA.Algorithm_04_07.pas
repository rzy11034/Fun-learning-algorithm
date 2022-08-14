unit FLA.Algorithm_04_07;

{$mode DelphiUnicode}

interface

uses
  Classes,
  SysUtils;


procedure Main;

implementation

type
  TSolution = class(TObject)
  public const
    maxn = 10005;
    M = 205;

  public type
    TArr = array[0..M] of integer;
    TArr2D = array[0..M, 0..maxn] of integer;
  end;

procedure Main;
begin
  with TSolution.Create do
  begin

    Free;
  end;
end;

end.
