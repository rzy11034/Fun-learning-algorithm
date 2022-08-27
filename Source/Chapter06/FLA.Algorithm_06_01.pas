unit FLA.Algorithm_06_01;

{$mode objfpc}{$H+}
{$ModeSwitch unicodestrings}
{$ModeSwitch advancedrecords}

interface

uses
  Classes,
  SysUtils,
  DeepStar.Utils,
  DeepStar.DSA.Linear.Queue;

procedure Main;

implementation

const
  _N_ = 10;

type
  TNode = record
    cp, rp, rw, id: integer;
    x: TArr_bool;
    constructor Create(newCp, newRp, newRw, newId: integer);
  end;

  TGoods = record
    Value, weight: integer;
  end;

  TArr_TGoods = array of TGoods;
  TQueue_TNode = specialize TQueue<TNode>;

var
  bestx: TArr_bool;
  goods: TArr_TGoods;
  bestp, w, n, sumw, sumv: integer;

function Bfs: integer;
var
  t, tcp, trp, trw, i: integer;
  q: TQueue_TNode;
  livendoe, lchild, rchild: TNode;
begin
  q := TQueue_TNode.Create();
  try
    q.EnQueue(TNode.Create(0, sumv, w, 1));

    while not q.IsEmpty do
    begin
      livendoe := q.DeQueue;
      t := livendoe.id;

      if (t > n) or (livendoe.id = 0) then
      begin
        if livendoe.cp >= bestp then
        begin
          for i := 1 to n do
            bestx[i] := livendoe.x[i];

          bestp := livendoe.cp;
        end;

        Continue;
      end;

      if livendoe.cp + livendoe.rp < bestp then
        Continue;

      tcp := livendoe.cp;
      trp := livendoe.rp - goods[t].Value;
      trw := livendoe.rw;

      if trw >= goods[t].weight then
      begin
        lchild.rw := trw - goods[t].weight;
        lchild.cp := tcp + goods[t].Value;
        lchild := TNode.Create(lchild.cp, trp, lchild.rw, t + 1);

        for i := 1 to t - 1 do
          lchild.x[i] := livendoe.x[i];

        lchild.x[t] := true;

        if lchild.cp > bestp then
          bestp := lchild.cp;

        q.EnQueue(lchild);
      end;

      if tcp + trp >= bestp then
      begin
        rchild := TNode.Create(tcp, trp, trw, t + 1);

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
  n := 4;
  w := 10;
  bestp := 0;
  sumw := 0;
  sumv := 0;
  SetLength(bestx, _N_);
  SetLength(goods, _N_);

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
  end;

  if sumw <= W then
  begin
    bestp := sumv;
    WriteLn('放入购物车的物品最大价值为：', bestp);
    WriteLn('所有的物品均放入购物车：');
    Exit;
  end;

  Bfs;
  WriteLn('放入购物车的物品最大价值为：', bestp);
  Write('放入购物车的物品序号为：');
  for i := 1 to n do
  begin
    if bestx[i] then
      Write(i, ' ');
  end;

  WriteLn;
end;

{ TNode }

constructor TNode.Create(newCp, newRp, newRw, newId: integer);
begin
  cp := newCp;
  rp := newRp;
  rw := newRw;
  id := newId;
  TArrayUtils_bool.SetLengthAndFill(x, _N_, false);
end;

end.
