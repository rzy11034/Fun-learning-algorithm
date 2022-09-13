unit FLA.Algorithm_07_09;

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
  INF = 1000000000;
  _N_ = 10000;
  _M_ = 150;

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
  top, maxflow, mincost: integer;
  str: TArr_str;
  maze: IMap_str_int;

procedure Init;
var
  i: integer;
begin
  SetLength(dist, _N_);
  SetLength(pre, _N_);
  SetLength(cs, _N_);
  SetLength(vis, _N_);
  SetLength(vs, _N_);
  SetLength(str, _N_);
  SetLength(es, _M_);

  for i := 0 to _N_ - 1 do
    vs[i].First := -1;

  top := 0;
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
  for i := 0 to High(pre) do
    pre[i] := -1;
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
  d, i: integer;
begin
  maxflow := 0;
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
    //maxflow += d;

    i := pre[t];
    while i <> -1 do
    begin
      es[i].flow += d;
      es[i xor 1].flow -= d;

      i := pre[es[i xor 1].v];
    end;

    maxflow += d;
    mincost += dist[t] * d;
  end;

  Result := maxflow;
end;

procedure Print(s, t: integer);
var
  i, v: integer;
begin
  vis[s] := true;

  i := vs[s].First;
  while (not i) <> 0 do
  begin
    v := es[i].v;
    if (not vis[v]) and ((es[i].flow > 0)
      and (es[i].cost <= 0) or (es[i].flow < 0) and (es[i].cost >= 0)) then
    begin
      Print(v, t);
      if v <= t then
        WriteLn(str[v]);
    end;

    i := es[i].Next;
  end;
end;

procedure Main;
var
  n, m, i, a, b: integer;
  str1, str2: string;
  s1: TArr_str;
  s2: TArr2D_str;
begin
  n := 8;
  m := 10;
  s1 := [
    'Zhengzhou',
    'Luoyang',
    'Xian',
    'Chengdu',
    'Kangding',
    'Xianggelila',
    'Motuo',
    'Lasa'];
  s2 := [
    ['Zhengzhou', 'Luoyang'],
    ['Zhengzhou', 'Xian'],
    ['Luoyang', 'Xian'],
    ['Luoyang', 'Chengdu'],
    ['Xian', 'Chengdu'],
    ['Xian', 'Xianggelila'],
    ['Chengdu', 'Lasa'],
    ['Kangding', 'Motuo'],
    ['Xianggelila', 'Lasa'],
    ['Motuo', 'Lasa']];

  Init;

  maze := TTreeMap_str_int.Create;
  for i := 1 to n do
  begin
    str[i] := s1[i - 1];
    maze.Add(str[i], i);

    if (i = 1) or (i = n) then
      Add(i, i + n, 2, 0)
    else
      Add(i, i + n, 1, 0);
  end;

  for i := 1 to m do
  begin
    str1 := s2[i - 1, 0];
    str2 := s2[i - 1, 1];

    a := maze.GetItem(str1);
    b := maze.GetItem(str2);

    if a < b then
    begin
      if (a = 1) and (b = n) then
        Add(a + n, b, 2, -1)
      else
        Add(a + n, b, 1, -1);
    end
    else
    begin
      if (b = 1) and (a = n) then
        Add(b + n, a, 2, -1)
      else
        Add(b + n, a, 1, -1);
    end;
  end;

  if MCMF(1, 2 * n, 2 * n) = 2 then
  begin
    WriteLn('最多经过的景点个数：', -mincost);
    WriteLn('依炊经过的景点：');
    WriteLn(str[1]);
    vis := nil;
    SetLength(vis, _N_);
    Print(1, n);
    WriteLn(str[1]);
  end
  else
  begin
    WriteLn('No, Solution!');
  end;
end;

end.
