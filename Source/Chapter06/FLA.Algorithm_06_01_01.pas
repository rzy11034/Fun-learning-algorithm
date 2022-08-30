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

  TObj = record
    id: integer;
    d: double;
    class function cmp(constref a, b: TObj): integer; static;
  end;

  TGoods = record
    weight, Value: integer;
  end;

  TArr_TObj = array of TObj;
  TArr_TGoods = array of TGoods;
  TPQ_TNode = specialize TPriorityQueue<TNode>;

var
  goods: TArr_TGoods;
  bestx: TArr_bool;
  ws, vs: TArr_Int;
  S: TArr_TObj;
  w, bestp, n, sumw, sumv: integer;

procedure Init;
begin
  SetLength(goods, _N_);
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
var
  a: TArr_int;
  q: IQueue_int;
  i: integer;
begin
  Init;
  n := 4;
  w := 10;
  sumw := 0;
  sumv := 0;

  a := [2, 6, 5, 3, 4, 5, 2, 4];
  q := TQueue_int.Create;
  for i := 0 to High(a) do
    q.EnQueue(a[i]);

  for i := 1 to n do
  begin
    goods[i].weight := q.DeQueue;
    goods[i].Value := q.DeQueue;
    sumw += goods[i].weight;
    sumv += goods[i].Value;
    S[i - 1].id := i;
    S[i - 1].d := 1.0 * goods[i].Value / goods[i].weight;
  end;

  if sumw <= W then
  begin
    bestp := sumv;
    WriteLn('放入购物车的物品最大价值为：', bestp);
    WriteLn('所有的物品均放入购物车：');
    Exit;
  end;

  specialize
  TArrayUtils<TObj>.Sort(s, 0, n, @TObj.cmp);
  WriteLn('排序后的物品重量和价值：');
  for i := 1 to n do
  begin
    ws[i] := goods[S[i - 1].id].weight;
    vs[i] := goods[S[i - 1].id].Value;
    WriteLn(ws[i], ' ', vs[i]);
  end;

  Priorbfs;
  WriteLn('放入购物车的物品最大价值为：', bestp);
  WriteLn('所有的物品均放入购物车：');
  for i := 1 to n do
  begin
    if bestx[i] then
      Write(S[i - 1].id, ' ');
  end;

  WriteLn;
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
