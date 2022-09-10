unit FLA.Algorithm_07_02_01;

{$mode ObjFPC}{$H+}

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

  TArr_TVertex = array of TVertex;
  TArr_TEdge = array of TEdge;

var
  hs, pres, gs: TArr_int;
  vs: TArr_TVertex;
  es: TArr_TEdge;
  i, j, top: integer;

procedure Init;
begin
  SetLength(vs, _N_);
  for i := 0 to High(vs) do
    vs[i].First := -1;

  SetLength(es, _M_);
  SetLength(pres, _N_);
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
  TArrayUtils_int.SetLengthAndFill(hs, _N_, -1);
  TArrayUtils_int.SetLengthAndFill(gs, _N_, 0);

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
        q.EnQueue(U);
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
        pres[v] := i;
        d := Min(d, es[i].cap - es[i].flow);
        if u = t then
        begin
          Write('增广路径', t);
          while u <> s do
          begin
            j := pres[u];
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
        u := es[pres[u] xor 1].v;
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

procedure PrintFlow(n: integer);
begin
  WriteLn('----------实流网络如下：---------');
  for i := 1 to n do
  begin
    j := vs[i].First;
    while (not j) <> 0 do
    begin
      if es[j].flow > 0 then
      begin
        Write('v', i, '--', 'v', es[j].v, ' ', es[j].flow);
        WriteLn;
      end;
      j := es[j].Next;
    end;
  end;
end;

procedure Main;
var
  a: TArr2D_int;
  n, m, u, v, w: integer;
begin
  n := 6;
  m := 9;
  a := [
    [1, 3, 10],
    [1, 2, 12],
    [2, 4, 08],
    [3, 5, 13],
    [3, 2, 02],
    [4, 6, 18],
    [4, 3, 05],
    [5, 6, 04],
    [5, 4, 06]];

  Init;

  for i := 0 to m - 1 do
  begin
    u := a[i, 0];
    v := a[i, 1];
    w := a[i, 2];
    Add(u, v, w);
  end;

  WriteLn;
  PrintGs(n);
  WriteLn('网络的最大流值：', Isap(1, n, n));
  WriteLn;
  PrintGs(n);
  PrintFlow(n);
end;

end.
