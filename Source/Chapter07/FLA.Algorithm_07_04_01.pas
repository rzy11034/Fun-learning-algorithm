unit FLA.Algorithm_07_04_01;

{$mode objfpc}{$H+}
{$ModeSwitch unicodestrings}

interface

uses
  Classes,
  SysUtils,
  DeepStar.Utils;

procedure Main;

implementation

const
  _N_ = 100;
  _M_ = 10000;

type
  TVertex = record
    First: integer;
  end;

  TEdge = record
    v, Next: integer;
  end;

var
  vs: array of TVertex;
  es: array of TEdge;
  match: TArr_int;
  vis: TArr_bool;
  i, j, top: integer;

procedure Init;
begin
  SetLength(match, _N_);
  SetLength(vis, _N_);
  SetLength(vs, _N_);
  SetLength(es, _M_);

  for i := 0 to _N_ - 1 do
  begin
    vs[i].First := -1;
  end;

  top := 0;
end;

procedure Add(u, v: integer);
begin
  es[top].v := v;
  es[top].Next := vs[u].First;
  vs[u].First := top;
  top += 1;
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
      Write(']--[', es[j].v, ' ', es[j].Next);
      j := es[j].Next;
    end;
    WriteLn(']');
  end;
end;

procedure Print(n: integer);
begin
  WriteLn('----------配对方案如下：---------');
  for i := 1 to n do
  begin
    if match[i] <> 0 then
    begin
      WriteLn(i, '--', match[i]);
    end;
  end;
end;

function MaxMatch(u: integer): boolean;
var
  v: integer;
begin
  j := vs[u].First;
  while (not j) <> 0 do
  begin
    v := es[j].v;
    if not vis[v] then
    begin
      vis[v] := true;
      if (not (match[v] <> 0)) or (MaxMatch(match[v])) then
      begin
        match[u] := v;
        match[v] := u;
        Exit(true);
      end;
    end;
    j := es[j].Next;
  end;

  Result := false;
end;


procedure Main;
var
  n, m, total, num, u, v: integer;
  a: TArr2D_int;
begin
  m := 5;
  n := 7;
  num := 0;
  a := [
    [1, 6],
    [1, 8],
    [2, 7],
    [2, 8],
    [2, 11],
    [3, 7],
    [3, 9],
    [3, 10],
    [4, 12],
    [4, 9],
    [5, 10]];

  Init;

  total := m + n;
  for i := 0 to High(a) do
  begin
    u := a[i, 0];
    v := a[i, 1];
    Add(u, v);
  end;

  PrintGs(total);
  for i := 1 to m do
  begin
    vis := nil;
    SetLength(vis, _N_);

    if MaxMatch(i) then
      num += 1;
  end;
  WriteLn('最大配对数：', num);
  Print(m);
end;

end.
