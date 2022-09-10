unit FLA.Algorithm_07_02_01;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  SysUtils,
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
    v, next, cap, flow: integer;
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
  top := 0;
end;

procedure Add_Edge(u, v, c:integer);
begin
  es[top].v := v;
  es[top].cap :=c;
  es[top].flow :=0;
  es[top].Next := vs[u].First;  
  vs[u].Fir := top;
  top +=1;
end;

procedure Add(u, v, c:integer);
begin
  Add_Edge(u,v,c);
  Add_Edge(v,u,0);
end;

procedure Set_h(t, n:integer);
var
  q: IQueue_int;
begin
  q := TQueue_int.Create;
  TArrayUtils_int.SetLengthAndFill(hs, _N_, -1);
  TArrayUtils_int.SetLengthAndFill(gs, _N_, 0);
  
  hs[t] := 0;
  q.EnQueue(t);
  
  while not q.IsEmpty do
  begin
    v := q.DeQueue;    
    gs[hs[v]] +=1;
    
    i:=vs[v].First;
    while (not i) = 0 do
    begin
      u := es[i].v;
      if hs[u] = -1 then
      begin
        hs[u] = hs[v]+1;
        q.EnQueue;
      end;
      
      i := es[i].next;
    end;
  end;
  
  WriteLn('初始化高度');
  Write('h[ ]');
  for i:=1 to n do
    Write(' ' , hs[s];
  WriteLn;
end;

function Isap(s, t, n:integer):integer;
var
  ans, u,d:integer;
begin
  Set_h(t, n);
  ans:=0; u=s;
  
  while hs[s]<n do
  begin
    if u=s then 
      d:=INF;
    
    i:vs[u].First;
    while (not i) 
  end;
end;

procedure Main;
begin
  Init;
end;

end.
