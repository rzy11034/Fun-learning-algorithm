﻿unit FLA.Algorithm_07_07;

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
  INF = $3FFFFFFF;
  _N_ = 100;
  _M_ = 10000;

type
  TVertex = record
    First: integer;
  end;

  TEdge = record
    v, Next, cap, flow: integer;
  end;

var
  vs: array of TVertex;
  es: array of TEdge;
  hs, pre, gs: TArr_int;
  flag: TArr_bool;
  i, j, top: integer;

procedure Init;
begin
  SetLength(hs, _N_);
  SetLength(pre, _N_);
  SetLength(gs, _N_);
  SetLength(vs, _N_);
  SetLength(es, _M_);
  SetLength(flag, _N_);

  for i := 0 to _N_ - 1 do
  begin
    vs[i].First := -1;
  end;

  top := 0;
end;

procedure Add_Edge(u, v, c: integer);
begin
  es[top].v := v;
  es[top].cap := c;
  es[top].flow := 0;
  es[top].Next := vs[u].First;
  vs[u].First := top;
  top += 1;
end;

procedure Add(u, v, c: integer);
begin
  Add_Edge(u, v, c);
  Add_Edge(v, u, 0);
end;

procedure Set_h(t, n: integer);
var
  q: IQueue_int;
  v, u: integer;
begin
  q := TQueue_int.Create;
  for i := 0 to _N_ - 1 do
  begin
    hs[i] := -1;
  end;

  hs[t] := 0;
  q.EnQueue(t);

  while not q.IsEmpty do
  begin
    v := q.DeQueue;
    gs[hs[v]] += 1;

    i := vs[v].First;
    while (not i) <> 0 do
    begin
      u := es[i].v;
      if hs[u] = -1 then
      begin
        hs[u] := hs[v] + 1;
        q.EnQueue(u);
      end;

      i := es[i].Next;
    end;
  end;

  WriteLn('初始化高度');
  Write('h[ ]');
  for i := 1 to n do
    Write(' ', hs[i]);
  WriteLn;
end;

function Isap(s, t, n: integer): integer;
var
  ans, u, d, v, hmin: integer;
begin
  Set_h(t, n);
  ans := 0;
  u := s;
  while hs[s] < n do
  begin
    if u = s then
      d := INF;

    i := vs[u].First;
    while (not i) <> 0 do
    begin
      v := es[i].v;
      if (es[i].cap > es[i].flow) and (hs[u] = hs[v] + 1) then
      begin
        u := v;
        pre[v] := i;
        d := Min(d, es[i].cap - es[i].flow);
        if u = t then
        begin
          Write('增广路径', t);
          while u <> s do
          begin
            j := pre[u];
            es[j].flow += d;
            es[j xor 1].flow -= d;
            u := es[j xor 1].v;
            Write('--', u);
          end;

          WriteLn('增流：', d);
          ans += d;
          d := INF;
        end;
        Break;
      end;
      i := es[i].Next;
    end;

    if i = -1 then
    begin
      if gs[hs[u]] = 0 then
      begin
        gs[hs[u]] -= 1;
        Break;
      end;

      hmin := n - 1;

      j := vs[u].First;
      while (not j) <> 0 do
      begin
        if es[j].cap > es[j].flow then
          hmin := Min(hmin, hs[es[j].v]);

        j := es[j].Next;
      end;

      hs[u] := hmin + 1;
      WriteLn('重贴标签后高度');
      Write('h[ ]=');
      for i := 1 to n do
        Write(' ', hs[i]);
      WriteLn;
      gs[hs[u]] += 1;

      if u <> s then
        u := es[pre[u] xor 1].v;
    end;
  end;

  Result := ans;
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
      Write(']--[', es[j].v, ' ', es[j].cap, ' ', es[j].flow, ' ', es[j].Next);
      j := es[j].Next;
    end;
    WriteLn(']');
  end;
end;

procedure DFS(s: integer);
var
  u,i: integer;
begin
  i := vs[s].First;
  while (not i) <> 0 do
  begin
    if es[i].cap > es[i].flow then
    begin
      u := es[i].v;
      if not flag[u] then
      begin
        flag[u] := true;
        DFS(u);
      end;
    end;
    i := es[i].Next;
  end;
end;

procedure Print(m, n: integer);
begin
  WriteLn('----------最大获益方案如下：---------');
  DFS(0);
  WriteLn('选中的实验编号：');
  for i := 1 to m do
    if flag[i] then
      Write(i, ' ');

  WriteLn;
  WriteLn('选中的仪器编号：');
  for i := m + 1 to m + n do
    if flag[i] then
      Write(i - m,' ');

  WriteLn;
end;

procedure Main;
var
  n, m, sum, total, cost, num, k: integer;
  a: TArr2D_int;
  b: TArr_int;
begin
  sum := 0;
  m := 5;
  n := 15;
  a := [
    [20, 2, 4, 8, 11, 0],
    [38, 1, 5, 14, 0],
    [25, 2, 5, 7, 15, 0],
    [17, 1, 3, 6, 13, 0],
    [22, 10, 12, 15, 0]];
  b := [2, 7, 4, 8, 10, 1, 3, 7, 5, 9, 15, 6, 12, 17, 8];

  Init;
  total := m + n;


  for i := 1 to m do
  begin
    k := 0;
    cost := a[i - 1, k];
    sum += cost;
    Add(0, i, cost);

    while a[i - 1, k] <> 0 do
    begin
      num := a[i - 1, k];
      Add(i, m + num, INF);
      k += 1;
    end;
  end;

  k := 0;
  for j := m + 1 to total do
  begin
    cost := b[k];
    Add(j, total + 1, cost);
    k += 1;
  end;

  PrintGs(total + 2);
  WriteLn('最大净收益：', sum - Isap(0, total + 1, total + 2));
  WriteLn;
  PrintGs(total + 2);
  Print(m, n);
end;

end.
