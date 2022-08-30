unit FLA.Algorithm_06_02;

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
    cl: double;
    id: integer;
    x: TArr_int;
    constructor Create(NewCl, NewId: integer);
    class function cmp(constref a, b: TNode): integer; static;
  end;

  TPQ = specialize TPriorityQueue<TNode>;

var
  g: TArr2D_dbl;
  bestx: TArr_int;
  bestl: double;
  n, m: integer;

function Travelingbfs: double;
var
  t, i, j: integer;
  livenode, newnode: TNode;
  q: TPQ;
  cl: double;
begin
  q := TPQ.Create(@TNode.cmp);
  try
    newnode := TNode.Create(0, 2);
    for i := 1 to n do
      newnode.x[i] := i;

    q.EnQueue(newnode);
    while not q.IsEmpty do
    begin
      livenode := q.DeQueue;
      t := livenode.id;

      if t = n then
      begin
        if (g[livenode.x[n - 1], livenode.x[n]] <> INF) and (g[livenode.x[n], 1] <> INF) then
        begin
          if livenode.cl + g[livenode.x[n - 1], livenode.x[n]] + g[livenode.x[n], 1] < bestl then
          begin
            bestl := livenode.cl + g[livenode.x[n - 1], livenode.x[n]] + g[livenode.x[n], 1];
            WriteLn;
            for i := 1 to n do
              bestx[i] := livenode.x[i];
          end;
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
          if cl < bestl then
          begin
            newnode := TNode.Create(trunc(cl), t + 1);
            for i := 1 to n do
              newnode.x[i] := livenode.x[i];

            specialize swap<integer>(newnode.x[t], newnode.x[j]);
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
  SetLength(bestx, _N_);
  SetLength(g, _N_, _N_);

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

  Travelingbfs;
  Print;
end;

{ TNode }

constructor TNode.Create(NewCl, NewId: integer);
begin
  cl := NewCl;
  id := NewId;
  SetLength(x, _N_);
end;

class function TNode.cmp(constref a, b: TNode): integer;
var
  res: integer;
begin
  if a.cl > b.cl then
    res := 1
  else if a.cl > b.cl then
    res := -1
  else
    res := 0;

  Result := res;
end;

end.
