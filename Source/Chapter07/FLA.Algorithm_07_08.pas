unit FLA.Algorithm_07_08;

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
  flag, dfsflag: TArr_bool;
  top: integer;

procedure Init;
var
  i: integer;
begin
  SetLength(hs, _N_);
  SetLength(pre, _N_);
  SetLength(gs, _N_);
  SetLength(vs, _N_);
  SetLength(es, _M_);
  SetLength(flag, _N_ * _N_);
  SetLength(dfsflag, _N_ * _N_);

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
  v, u, i: integer;
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
  ans, u, d, v, hmin, i, j: integer;
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
      gs[hs[u]] -= 1;
      if gs[hs[u]] = 0 then
        Break;

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
var
  i, j: integer;
begin
  WriteLn('----------网络邻接表如下：----------');
  for i := 0 to n do
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
  u, i: integer;
begin
  i := vs[s].First;
  while (not i) <> 0 do
  begin
    if es[i].cap > es[i].flow then
    begin
      u := es[i].v;
      if not dfsflag[u] then
      begin
        dfsflag[u] := true;
        DFS(u);
      end;
    end;
    i := es[i].Next;
  end;
end;

procedure Print(m, n: integer);
var
  i: integer;
begin
  WriteLn('----------最佳方案如下：---------');
  WriteLn('选中的物品编号：');
  DFS(0);
  for i := 1 to m * n do
    if (flag[i] and dfsflag[i]) or ((not flag[i]) and (not dfsflag[i])) then
      Write(i, ' ');
end;

procedure Main;
var
  n, m, sum, total, i, j, k, x, y: integer;
  map, dir, a: TArr2D_int;
begin
  m := 4;
  n := 4;
  sum := 0;
  dir := [[0, 1], [1, 0], [0, -1], [-1, 0]];
  SetLength(map, _N_, _N_);
  a := [
    [10, 8, 5, 2],
    [1, 3, 9, 15],
    [5, 10, 13, 7],
    [24, 12, 20, 14]];

  Init;
  total := m + n;

  for i := 1 to m do
  begin
    for j := 1 to n do
    begin
      map[i, j] := a[i - 1, j - 1];
      sum += map[i, j];
    end;
  end;

  for i := 1 to m do
  begin
    for j := 1 to n do
    begin
      if (i + j) mod 2 = 0 then
      begin
        Add(0, (i - 1) * n + j, map[i, j]);
        flag[(i - 1) * n + j] := true;

        for k := 0 to 3 do
        begin
          x := i + dir[k, 0];
          y := j + dir[k, 1];

          if ((x <= m) and (x > 0)) and ((y <= n) and (y > 0)) then
            Add((i - 1) * n + j, (x - 1) * n + y, INF);
        end;
      end
      else
      begin
        Add((i - 1) * n + j, total + 1, map[i, j]);
      end;
    end;
  end;

  WriteLn;
  PrintGs(total + 2);
  WriteLn('挑选物品的最大价值：', sum - Isap(0, total + 1, total + 2));
  WriteLn;
  PrintGs(total + 2);
  Print(m, n);
  WriteLn;
end;

end.
