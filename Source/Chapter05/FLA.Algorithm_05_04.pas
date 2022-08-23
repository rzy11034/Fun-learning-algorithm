unit FLA.Algorithm_05_04;

{$mode DelphiUnicode}

interface

uses
  Classes,
  SysUtils;

procedure Main;

implementation

const
  M = 105;

var
  x: array[0..M] of integer;
  n, countn: integer;

function Place(t: integer): boolean;
var
  ok: boolean;
  j: integer;
begin
  ok := true;
  for j := 1 to t - 1 do
  begin
    if (x[t] = x[j]) or (t - j = Abs(x[t] - x[j])) then
    begin
      ok := false;
      Break;
    end;
  end;

  Result := ok;
end;

procedure Backtrack(t: integer);
var
  i: integer;
begin
  if t > n then
  begin
    countn += 1;
    for i := 1 to n do
      Write(x[i], ' ');
    WriteLn;
    WriteLn('----------');
  end
  else
  begin
    for i := 1 to n do
    begin
      x[t] := i;
      if Place(t) then
        Backtrack(t + 1);
    end;
  end;
end;

procedure Main;
begin
  n := 8;
  countn := 0;
  Backtrack(1);
  WriteLn('答案的个数是：', countn);
end;

end.
