unit FLA.Algorithm_02_02;

{$mode ObjFPC}{$H+}
{$ModeSwitch advancedrecords}

interface

uses
  Classes,
  SysUtils,
  Math,
  DeepStar.Utils;

procedure Main;

implementation

type
  TThree = record
    W: double; // 重量
    V: double; // 价值
    P: double; // 性价比
    class function cmp(constref left, right: TThree): integer; static;
  end;

  TArrayUtils_TThree = specialize TArrayUtils<TThree>;

const
  W_CONST: array of TThree = (
    //(W: 6; V: 19; P: -1),
    (W: 2; V: 8; P: -1),
    (W: 6; V: 1; P: -1),
    (W: 7; V: 9; P: -1),
    (W: 4; V: 3; P: -1),
    (W: 10; V: 2; P: -1),
    (W: 3; V: 4; P: -1));

procedure Main;
var
  w: array of TThree;
  i: integer;
  sum, m: double;
begin
  w := TArrayUtils_TThree.CopyArray(W_CONST);
  for i := 0 to High(w) do
    w[i].P := RoundTo(w[i].v / w[i].W, -2);

  for i := 0 to High(w) do
    WriteLnF('%8f  %8f  %8f', [w[i].W, w[i].V, w[i].P]);

  DrawLineBlockEnd;

  TArrayUtils_TThree.Sort(w, TArrayUtils_TThree.TCmp_T.Construct(@TThree.cmp));

  for i := 0 to High(w) do
    WriteLnF('%8f  %8f  %8f', [w[i].W, w[i].V, w[i].P]);

  DrawLineBlockEnd;

  sum := 0;
  m := 19;

  for i := 0 to High(w) do
  begin
    if m > w[i].W then
    begin
      sum += w[i].V;
      m -= w[i].W;
    end
    else
    begin
      sum += m * w[i].P;
      Break;
    end;
  end;

  WriteLnF('%f', [sum]);
end;

{ TThree }

class function TThree.cmp(constref left, right: TThree): integer;
begin
  Result := 0;

  if left.P <> right.P then
    Result := specialize IfThen<integer>(left.P < right.P, 1, -1);
end;

end.
