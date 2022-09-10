unit FLA.Algorithm_07_02;

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
  maxn = 100;
  INF = (1 << 30) - 1;

var
  g, f: TArr2D_int64;
  pre: TArr_int;
  vis: TArr_bool;
  i, j, n, m: integer;

procedure Init;
begin
  SetLength(g, maxn, maxn);
  SetLength(f, maxn, maxn);
  SetLength(pre, maxn);
  SetLength(vis, maxn);
end;

function bfs(s, t: integer): boolean;
var
  q: TQueue_int;
  now: integer;
begin
  TArrayUtils_int.SetLengthAndFill(pre, maxn, -1);
  TArrayUtils_bool.SetLengthAndFill(vis, maxn, false);

  q := TQueue_int.Create();
  try
    vis[s] := true;
    q.EnQueue(s);

    while not q.IsEmpty do
    begin
      now := q.DeQueue;

      for i := 1 to n do
      begin
        if (not vis[i]) and (g[now, i] > 0) then
        begin
          vis[i] := true;
          pre[i] := now;

          if i = t then
            Exit(true);

          q.EnQueue(i);
        end;
      end;
    end;

    Result := false;
  finally
    q.Free;
  end;
end;

function EK(s, t: integer): integer;
var
  v, w, d, maxflow: integer;
begin
  maxflow := 0;
  while Bfs(s, t) do
  begin
    v := t;
    d := INF;

    while v <> s do
    begin
      w := pre[v];

      if d > g[w, v] then
        d := g[w, v];

      v := w;
    end;

    maxflow += d;
    v := t;

    while v <> s do
    begin
      w := pre[v];
      g[w, v] -= d;
      g[v, w] += d;

      if f[v, w] > 0 then
        f[v, w] -= d
      else
        f[w, v] += d;
        
      v:=w;
    end;
  end;

  Result := maxflow;
end;

procedure Print;
begin
  WriteLn('----------实流网络如下：---------');
  Write(' ');

  for i := 1 to n do
    WriteF('%7s%d', ['v', i]);
  WriteLn;

  for i := 1 to n do
  begin
    Write('v', i);
    for j := 1 to n do
      WriteF('%7d ', [f[i, j]]);
    WriteLn;
  end;
end;

procedure Main;
var
  a: TArr2D_int; u, v, w: integer;
begin
  n := 6;
  m := 9;
  a := [
    [1, 2, 12],
    [1, 3, 10],
    [2, 4, 08],
    [3, 2, 02],
    [3, 5, 13],
    [4, 3, 05],
    [4, 6, 18],
    [5, 4, 06],
    [5, 6, 04]];

  Init;

  for i := 0 to m - 1 do
  begin
    u := a[i, 0];
    v := a[i, 1];
    w := a[i, 2];
    g[u, v] += w;
  end;

  WriteLn('网络的最大流值：', EK(1, n));
  Print;
end;

end.
