unit FLA.Algorithm_06_02_01;

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
  INF = Round(1E7);
  _N_ = 100;

type
  TNode = record
    cl, rl, zl: double;
    id: integer;
    x: TArr_Int;
    constructor Create(_cl, _rl, _zl: double; _id: integer);
    class function cmp(constref a, b: TNode): integer; static;
  end;

  TPQ = specialize TPriorityQueue<TNode>;

var
  g: TArr2D_dbl;
  minout: TArr_dbl;
  bestx: TArr_Int;
  minsum, bestl: double;
  n, m: integer;

function Bound: boolean;
var
  i, j: integer;
  min1: double;
begin
  for i := 1 to n do
  begin
    min1 := INF;
    for j := 1 to n do
      if (g[i, j] <> INF) and (g[i, j] < min1) then
        min1 := g[i, j];

    if min1 = INF then
      Exit(false);

    minout[i] := min1;
    minsum += min1;
  end;

  Result := true;
end;

function Travelingbfssopt: double;
var
  livenode, newnode: TNode;
  q: TPQ;
  i, t, j: integer;
  cl, rl, zl: double;
begin
  if not Bound then
    Exit(-1);

  q := TPQ.Create(@TNode.cmp);
  try
    newnode := TNode.Create(0, minsum, minsum, 2);
    for i := 0 to n do
      newnode.x[i] := i;

    q.EnQueue(newnode);
    while not q.IsEmpty do
    begin
      livenode := q.DeQueue;
      t := livenode.id;

      if t = n then
      begin
        if (g[livenode.x[n - 1], livenode.x[n]] <> INF) and (g[livenode.x[n], 1] <> INF) then
          if livenode.cl + g[livenode.x[n - 1], livenode.x[n]] + g[livenode.x[n], 1] < bestl then
          begin
            bestl := livenode.cl + g[livenode.x[n - 1], livenode.x[n]] + g[livenode.x[n], 1];
            for i := 1 to n do
              bestx[i] := livenode.x[i];
          end;
        Continue;
      end;

      if livenode.cl >= bestl then
        Continue;

      for j := t to n do
      begin
        if g[livenode.x[t - 1], livenode.x[j]] <> INF then
        begin
          cl := livenode.cl + g[livenode.x[t - 1], livenode.x[j]];
          rl := livenode.rl - minout[livenode.x[j]];;
          zl := cl + rl;
          if zl < bestl then
          begin
            newnode := TNode.Create(cl, rl, zl, t + 1);
            for i := 1 to n do
              newnode.x[i] := livenode.x[i];

            specialize Swap<integer>(newnode.x[t], newnode.x[j]);
            q.EnQueue(newnode);
          end;
        end;
      end;
    end;

    Result := bestl;
  finally
    q.Free;
  end;
end;

procedure Init;
var
  i, j: integer;
begin
  bestl := INF;
  minsum := 0;
  SetLength(g, _N_, _N_);
  SetLength(minout, _N_);
  SetLength(bestx, _N_);

  for i := 0 to n do
    bestx[i] := 0;

  for i := 0 to n do
  begin
    for j := i to n do
    begin
      g[i, j] := INF;
      g[j, i] := INF;
    end;
  end;
end;

procedure Print;
var
  i: integer;
begin
  WriteLn;
  Write('最短路径：');
  for i := 1 to n do
    Write(bestx[i], '--->');

  WriteLn('1');
  WriteLn('最短路径长度：', bestl.ToString);
end;

procedure Main;
var
  us, vs, ws: TArr_int;
  u, v, w, i: integer;
begin
  n := 4;
  m := 6;
  us := [1, 1, 1, 2, 2, 3];
  vs := [2, 3, 4, 3, 4, 4];
  ws := [15, 30, 5, 6, 12, 3];

  Init;

  for i := 0 to m - 1 do
  begin
    u := us[i];
    v := vs[i];
    w := ws[i];

    g[u, v] := w;
    g[v, u] := w;
  end;

  Travelingbfssopt;
  Print;
end;

{ TNode }

constructor TNode.Create(_cl, _rl, _zl: double; _id: integer);
begin
  cl := _cl;
  rl := _rl;
  zl := _zl;
  id := _id;
  SetLength(x, _N_);
end;

class function TNode.cmp(constref a, b: TNode): integer;
var
  res: integer;
begin
  if a.zl > b.zl then
    res := 1
  else if a.zl < b.zl then
    res := -1
  else
    res := 0;

  Result := res;
end;

end.
