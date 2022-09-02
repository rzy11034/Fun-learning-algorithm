unit FLA.Algorithm_06_03;

{$mode objfpc}{$H+}
{$ModeSwitch unicodestrings}
{$ModeSwitch advancedrecords}

interface

uses
  Classes,
  SysUtils,
  DeepStar.Utils,
  DeepStar.DSA.Linear.Queue;

procedure Main;

implementation

const
  DIR: array[0..3] of TPoint = (
    (x: 0; y: 1),
    (x: 1; y: 0),
    (x: 0; y: -1),
    (x: -1; y: 0));

type
  TQueue_TPoint = specialize TQueue<TPoint>;
  TArr_TPoint = array of TPoint;

var
  grid: TArr2D_int;

function Findpath(s, e: TPoint; var path: TArr_TPoint; var pathLen: integer): boolean;
var
  here, Next: TPoint;
  q: TQueue_TPoint;
  i, j: integer;
begin
  if (s.x = e.x) and (s.y = e.y) then
  begin
    pathLen := 0;
    Exit(true);
  end;

  here := s;
  grid[s.x, s.y] := 0;

  q := TQueue_TPoint.Create();
  try
    while true do
    begin
      for i := 0 to High(DIR) do
      begin
        Next.x := here.x + DIR[i].x;
        Next.y := here.y + DIR[i].y;

        if grid[Next.x, Next.y] = -1 then;
        begin
          grid[Next.x, Next.y] := grid[here.x, here.y] + 1;
          q.EnQueue(Next);
        end;

        if (Next.x = e.x) and (Next.y = e.y) then
          Break;
      end;

      if (Next.x = e.x) and (Next.y = e.y) then
        Break;

      if q.IsEmpty then
        Exit(false)
      else
        here := q.DeQueue;
    end;
  finally
    q.Free;
  end;

  pathLen := grid[e.x, e.y];
  SetLength(path, pathLen);
  here := e;
  for j := pathLen - 1 downto 0 do
  begin
    path[j] := here;
    for i := 0 to High(DIR) do
    begin
      Next.x := here.x + DIR[i].x;
      Next.y := here.y + DIR[i].y;
      if grid[Next.x, Next.y] = j then
        Break;
    end;
    here := Next;
  end;
  Result := true;
end;

procedure Init(m, n: integer);
var
  i, j: integer;
begin
  TArrayUtils_int.SetLengthAndFill(grid, 100, 100);

  for i := 1 to m do
    for j := 1 to n do
      grid[i, j] := -1;

  for i := 0 to n + 1 do
  begin
    grid[0, i] := -2;
    grid[m + 1, i] := -2;
  end;

  for i := 0 to m + 1 do
  begin
    grid[i, 0] := -2;
    grid[i, n + 1] := -2;
  end;
end;

procedure Main;
var
  p, way: TArr_TPoint;
  a, b: TPoint;
  m, n, len, i: integer;
begin
  m := 5;
  n := 6;
  Init(m, n);
  p := [
    TPoint.Create(1, 6),
    TPoint.Create(2, 3),
    TPoint.Create(3, 4),
    TPoint.Create(5, 1)];

  for i := 0 to High(p) do
  begin
    grid[p[i].x, p[i].y] := -2;
  end;

  a := TPoint.Create(2, 1);
  b := TPoint.Create(4, 6);

  if Findpath(a, b, way, len) then
  begin
    WriteLn('该条最短路径的长度为：', len);
    WriteLn('最佳路径坐标为：');
    for i := 0 to len - 1 do
      WriteLnF('%2d%2d', [way[i].x, way[i].y]);
  end
  else
  begin
    WriteLn('任务无法达成。');
  end;
end;

end.
