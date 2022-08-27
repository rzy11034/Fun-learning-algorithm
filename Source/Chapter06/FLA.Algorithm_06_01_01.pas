unit FLA.Algorithm_06_01_01;

{$mode objfpc}{$H+}
{$ModeSwitch unicodestrings}
{$ModeSwitch advancedrecords}

interface

uses
  Classes,
  SysUtils,
  DeepStar.Utils,
  DeepStar.DSA.Tree.PriorityQueue;

procedure Main;

implementation

const
  _N_ = 10;

type
  TNode = record
    cp, rw, id: integer;
    up: double;
    x: TArr_bool;
    constructor Create(newCp: integer; newUp: double; newRw, newId: integer);
    class function cmp(constref a, b: TNode): integer; static;
  end;

  TGoods = record
    Value, weight: integer;
  end;

  TObj = record
    id: integer;
    d: double;
    class function cmp(constref a, b: TObj): integer; static;
  end;

  TArr_TGoods = array of TGoods;
  TArr_TObj = array of TObj;
  TPQ_TNode = specialize TPriorityQueue<TNode>;

var
  bestx: TArr_bool;
  ws, vs: TArr_Int;
  S: TArr_TObj;
  w, bestp, n, sumw, sumv: integer;

procedure Init;
begin
  SetLength(bestx, _N_);
  SetLength(ws, _N_);
  SetLength(vs, _N_);
  SetLength(S, _N_);
end;

function Bound(node: TNode): double;
var
  MaxValue, left: double;
  t: integer;
begin
  MaxValue := node.cp;
  t := node.id;
  left := node.rw;

  while (t <= n) and (ws[t] <= Left) do
  begin
    MaxValue += vs[t];
    left -= ws[t];
  end;

  if t <= n then
    MaxValue += 1.0 * vs[t] / ws[t] * left;

  Result := MaxValue;
end;

function Priorbfs: integer;
var
  t, tcp, tup, trw, i: integer;
  q: TPQ_TNode;
  livendoe, lchild, rchild: TNode;
begin
  q := TPQ_TNode.Create(TPQ_TNode.TCmp.Construct(@TNode.cmp));
  try
    q.EnQueue(TNode.Create(0, sumv, w, 1));
    while not q.IsEmpty do
    begin
      livendoe := q.DeQueue;
      t := livendoe.id;

      if (t > n) or (livendoe.rw = 0) then
      begin
        if livendoe.cp >= bestp then
        begin
          for i := 1 to n do
            bestx[i] := livendoe.x[i];

          bestp := livendoe.cp;
        end;

        Continue;
      end;

      if livendoe.up < bestp then
        Continue;

      tcp := livendoe.cp;
      trw := livendoe.rw;

      if trw >= ws[t] then
      begin
        lchild.cp := tcp + vs[t];
        lchild.rw := trw - ws[t];
        lchild.id := t + 1;
        tup := round(Bound(lchild));
        lchild := TNode.Create(lchild.cp, tup, lchild.rw, t + 1);

        for i := 1 to t - 1 do
          lchild.x[i] := livendoe.x[i];

        lchild.x[t] := true;

        if lchild.cp > bestp then
          bestp := lchild.cp;

        q.EnQueue(lchild);
      end;

      rchild.cp := tcp;
      rchild.rw := trw;
      rchild.id := t + 1;
      tup := round(Bound(rchild));

      if tup >= bestp then
      begin
        rchild := TNode.Create(tcp, tup, trw, t + 1);
        for i := 1 to t - 1 do
          rchild.x[i] := livendoe.x[i];

        rchild.x[t] := false;
        q.EnQueue(rchild);
      end;
    end;

    Result := bestp;
  finally
    q.Free;
  end;
end;

procedure Main;
begin
end;

{ TObj }

class function TObj.cmp(constref a, b: TObj): integer;
var
  res: integer;
begin
  if a.d > b.d then
    res := 1
  else if a.d < b.d then
    res := -1
  else
    res := 0;

  Result := res;
end;

{ TNode }

constructor TNode.Create(newCp: integer; newUp: double; newRw, newId: integer);
begin
  cp := newCp;
  up := newUp;
  rw := newRw;
  id := newId;
  TArrayUtils_bool.SetLengthAndFill(x, _N_, false);
end;

class function TNode.cmp(constref a, b: TNode): integer;
var
  res: integer;
begin
  if a.up < b.up then
    res := 1
  else if a.up > b.up then
    res := -1
  else
    res := 0;

  Result := res;
end;

end.
