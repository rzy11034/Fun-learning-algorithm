unit FLA.Algorithm_07_03;

{$mode objfpc}{$H+}
{$ModeSwitch unicodestrings}

interface

uses
  Classes,
  SysUtils,
  Math,
  DeepStar.Utils;

procedure Main;

implementation

const
  INF = 1000000;
  _N_ = 100;
  _M_ = 10000;

type
  TVertex = record
    First: integer;
  end;

  TEdge = record
    v, Next, cap, flow, cost: integer;
  end;

var
  dist, pre, cs: TArr_int;
  vis: TArr_bool;
  vs: array of TVertex;
  es: array of TEdge;
  i, j, top, maxflow: integer;

procedure Init;
begin
  SetLength(dist, _N_);
  SetLength(pre, _N_);
  SetLength(cs, _N_);
  SetLength(vis, _N_);
  SetLength(vs, _N_);
  SetLength(es, _M_);

  for i := 0 to _N_ - 1 do
  begin
    vs[i].First := -1;
    pre[i] := -1;
  end;

  top := 0;
  maxflow := 0;
end;

procedure Add_Edge(u, v, c, cost: integer);
begin
  es[top].v := v;
  es[top].cap := c;
  es[top].cost := cost;
  es[top].flow := 0;
  es[top].Next := vs[u].First;
  vs[u].First := top;
  top += 1;
end;

procedure Add(u, v, c, cost: integer);
begin
  Add_Edge(u, v, c, cost);
  Add_Edge(v, u, 0, -cost);
end;

function SPFA(s, t, n: integer): boolean;
var
  i, u, v: integer;
  q: IQueue_int;
begin
  q := TQueue_int.Create;
  for i := 1 to n do
    dist[i] := INF;
  vis[s] := true;
  cs[s] += 1;
  dist[s] := 0;
  q.EnQueue(s);

  while not q.IsEmpty do
  begin
    u := q.DeQueue;
    vis[u] := false;

    i := vs[u].First;
    while i <> -1 do
    begin
      v := es[i].v;
      if (es[i].cap > es[i].flow) and (dist[v] > dist[u] + es[i].cost) then
      begin
        dist[v] := dist[u] + es[i].cost;
        pre[v] := i;
        if not vis[v] then
        begin
          cs[v] += 1;
          q.EnQueue(v);
          vis[v] := true;

          if cs[v] > n then
            Exit(false);
        end;
      end;

      i := es[i].Next;
    end;
  end;

  WriteLn('最短路数组');
  Write('dist[ ]=');

  for i := 1 to n do
    Write(' ', dist[i]);
  WriteLn;

  if dist[t] = INF then
    Exit(false);

  Result := true;
end;

function MCMF(s, t, n: integer): integer;
var
  d, mincost: integer;
begin
  mincost := 0;

  while SPFA(s, t, n) do
  begin
    d := INF;
    Write('增广路径：', t);

    i := pre[t];
    while i <> -1 do
    begin
      d := Min(d, es[i].cap - es[i].flow);
      Write('--', es[i xor 1].v);

      i := pre[es[i xor 1].v];
    end;

    WriteLn('增流：', d);
    WriteLn;
    maxflow += d;

    i := pre[t];
    while i <> -1 do
    begin
      es[i].flow += d;
      es[i xor 1].flow -= d;

      i := pre[es[i xor 1].v];
    end;

    mincost += dist[t] * d;
  end;

  Result := mincost;
end;

procedure PrintGs(n: integer);
begin
  WriteLn('----------网络邻接表如下：----------');
  for i := 1 to n do
  begin
    Write('v', i, ' [', vs[i].First);

    j := vs[i].First;
    while (not j) <> 0 do
    begin
      Write(']--[', es[j].v, ' ', es[j].cap, ' ', es[j].flow, ' ',
        es[j].cost, ' ', es[j].Next);
      j := es[j].Next;
    end;
    WriteLn(']');
  end;
  WriteLn;
end;

procedure PrintFlow(n: integer);
begin
  WriteLn('----------实流边如下：---------');
  for i := 1 to n do
  begin
    j := vs[i].First;
    while (not j) <> 0 do
    begin
      if es[j].flow > 0 then
      begin
        Write('v', i, '--', 'v', es[j].v, ' ', es[j].flow, ' ', es[j].cost);
        WriteLn;
      end;
      j := es[j].Next;
    end;
  end;
end;

procedure Main;
var
  n, m, u, v, w, c: integer;
  a: TArr2D_int;
begin
  n := 6;
  m := 10;
  a := [
    [1, 3, 4, 7],
    [1, 2, 3, 1],
    [2, 5, 4, 5],
    [2, 4, 6, 4],
    [2, 3, 1, 1],
    [3, 5, 3, 6],
    [3, 4, 5, 3],
    [4, 6, 7, 6],
    [5, 6, 3, 2],
    [5, 4, 3, 3]];

  Init;

  for i := 0 to m - 1 do
  begin
    u := a[i, 0];
    v := a[i, 1];
    w := a[i, 2];
    c := a[i, 3];

    Add(u, v, w, c);
  end;

  PrintGs(n);
  WriteLn('网络的最小费用：', MCMF(1, n, n));
  WriteLn('网络的最大流值：', maxflow);
  WriteLn;
  PrintGs(n);
  PrintFlow(n);
end;

end.
