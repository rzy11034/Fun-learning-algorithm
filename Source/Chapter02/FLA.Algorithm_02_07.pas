unit FLA.Algorithm_02_07;

{$mode objfpc}{$H+}
{$ModeSwitch unicodestrings}
{$ModeSwitch advancedrecords}

interface

uses
  Classes,
  SysUtils,
  DeepStar.DSA.Linear.ArrayList,
  DeepStar.Utils;

procedure Main;

implementation

type
  TPrim = class(TObject)
  private
    _INF: integer;
    _N: integer;
    _Graph: TArr2D_int;
    _Res: IList_int;

    procedure __Prim;

  public
    constructor Create;
    destructor Destroy; override;

    procedure PrintGraph;
    function Mst: integer;
  end;

  TKruskal = class(TObject)
  private type
    TEdge = record
      V1, V2, Weight: integer;
      constructor Create(newV1, newV2, newWeight: integer);
      class function Comparer(constref a, b: TEdge): integer; static;
      function ToString: string;
    end;

    TArr_TEdge = array of TEdge;

  private
    _INF: integer;
    _N: integer;
    _Graph: TArr2D_int;
    _Res: IList_int;
    _Edges: TArr_TEdge;
    _NodeSet: TArr_int;
    _Mst: integer;

    function __GetEDges: TArr_TEdge;
    function __Merge(v1, v2: integer): boolean;
    procedure __Kruskal;

  public
    constructor Create;
    destructor Destroy; override;

    procedure PrintGraph;
    function Mst: integer;
  end;

const
  GRAPH_VALUE: TArr_str = (
    '1 2 23',
    '1 6 28',
    '1 7 36',
    '2 3 20',
    '2 7 1',
    '3 4 15',
    '3 7 4',
    '4 5 3',
    '4 7 9',
    '5 6 17',
    '5 7 16',
    '6 7 25');
  CHR = #$221e; // CHR = '∞';

procedure Main;
begin
  writeln('Prim:');
  with TPrim.Create do
  begin
    WriteLn('mst: ', Mst);
    Free;
  end;

  DrawLineProgramEnd;
  writeln;

  writeln('Kruskal:');
  with TKruskal.Create do
  begin
    WriteLn('mst: ', Mst);
    Free;
  end;
end;

{ TKruskal.TEdge }

constructor TKruskal.TEdge.Create(newV1, newV2, newWeight: integer);
begin
  with Self do
  begin
    V1 := newV1;
    V2 := newV2;
    Weight := newWeight;
  end;
end;

class function TKruskal.TEdge.Comparer(constref a, b: TEdge): integer;
begin
  Result := a.Weight - b.Weight;
end;

function TKruskal.TEdge.ToString: string;
begin
  Result := Format('[%d -> %d: %d]', [V1, V2, Weight]);
end;

{ TKruskal }

constructor TKruskal.Create;
var
  i, v1, v2, weight: integer;
  sl: TStringList;
begin
  _INF := $7FFFFFFF;
  _N := 8;
  TArrayUtils_int.SetLengthAndFill(_Graph, _N, _N, _INF);
  _Res := TArrayList_int.Create(_N);

  SetLength(_NodeSet, _N);
  for i := 0 to High(_NodeSet) do
    _NodeSet[i] := i;


  //**************************************************************

  sl := TStringList.Create();
  try
    for i := 0 to High(GRAPH_VALUE) do
    begin
      sl.AddDelimitedtext(GRAPH_VALUE[i]);
      v1 := sl.Count;
      v2 := Length(sl.ToStringArray);

      v1 := sl[0].ToInteger;
      v2 := sl[1].ToInteger;
      weight := sl[2].ToInteger;

      _Graph[v1, v2] := weight;
      _Graph[v2, v1] := weight;

      sl.Clear;
    end;
  finally
    sl.Free;
  end;

  PrintGraph;
  _Edges := __GetEDges;
  __Kruskal;
end;

destructor TKruskal.Destroy;
begin
  inherited Destroy;
end;

function TKruskal.Mst: integer;
begin
  Result := _Mst;
end;

procedure TKruskal.PrintGraph;
var
  i, j, weight: integer;
begin
  for i := 1 to High(_Graph) do
  begin
    for j := 1 to High(_Graph[i]) do
    begin
      weight := _Graph[i, j];
      if weight = _INF then
        WriteF('%s'#9, [CHR])
      else
        WriteF('%d'#9, [weight]);
    end;
    WriteLn;
  end;

  DrawLineBlockEnd;
end;

function TKruskal.__GetEDges: TArr_TEdge;
type
  TList_Edge = specialize TArrayList<TEdge>;
  TArrayUtils_TEdge = specialize TArrayUtils<TEdge>;
var
  list: TList_Edge;
  i, j: integer;
  edge: integer = 0;
  e: TEdge;
begin
  for i := 1 to High(_Graph) do
  begin
    for j := i + 1 to High(_Graph) do
    begin
      if _Graph[i, j] <> _INF then
        edge += 1;
    end;
  end;

  list := TList_Edge.Create;
  try
    for i := 1 to High(_Graph) do
    begin
      for j := i + 1 to High(_Graph) do
      begin
        if _Graph[i, j] <> _INF then
        begin
          e := TEdge.Create(i, j, _Graph[i, j]);

          list.AddLast(e);
        end;
      end;
    end;

    edge := list.Count;
    Result := list.ToArray;
  finally
    list.Free;
  end;

  {$IFDEF DEBUG}
  for i := 0 to High(Result) do
    Write(Result[i].Tostring, #9);
  WriteLn;
  DrawLineBlockEnd;

  TArrayUtils_TEdge.Sort(Result, @TEdge.Comparer);
  for i := 0 to High(Result) do
    Write(Result[i].Tostring, #9);
  WriteLn;
  DrawLineBlockEnd;
  {$ENDIF}
end;

procedure TKruskal.__Kruskal;
var
  i: integer;
begin
  _Mst := 0;

  for i := 0 to High(_Edges) do
  begin
    if __Merge(_Edges[i].V1, _Edges[i].V2) then
    begin
      _Mst += _Edges[i].Weight;
    end;
  end;
end;

function TKruskal.__Merge(v1, v2: integer): boolean;
var
  p, q, i: integer;
begin
  p := _NodeSet[v1];
  q := _NodeSet[v2];

  if p = q then Exit(false);

  for i := 1 to High(_NodeSet) do
  begin
    if _NodeSet[i] = q then
      _NodeSet[i] := p;
  end;

  Result := true;
end;

{ TSolustion }

constructor TPrim.Create;
var
  i, v1, v2, weight: integer;
  sl: TStringList;
begin
  _INF := $7FFFFFFF;
  _N := 8;
  TArrayUtils_int.SetLengthAndFill(_Graph, _N, _N, _INF);
  _Res := TArrayList_int.Create(_N);

  sl := TStringList.Create();
  try
    for i := 0 to High(GRAPH_VALUE) do
    begin
      sl.AddDelimitedtext(GRAPH_VALUE[i]);
      v1 := sl.Count;
      v2 := Length(sl.ToStringArray);

      v1 := sl[0].ToInteger;
      v2 := sl[1].ToInteger;
      weight := sl[2].ToInteger;

      _Graph[v1, v2] := weight;
      _Graph[v2, v1] := weight;

      sl.Clear;
    end;
  finally
    sl.Free;
  end;

  PrintGraph;
  __Prim;
end;

destructor TPrim.Destroy;
begin
  inherited Destroy;
end;

function TPrim.Mst: integer;
var
  i: integer;
begin
  Result := 0;

  for i := 0 to _Res.Count - 1 do
    Result += _Res[i];
end;

procedure TPrim.PrintGraph;
var
  i, j, weight: integer;
begin
  for i := 1 to High(_Graph) do
  begin
    for j := 1 to High(_Graph[i]) do
    begin
      weight := _Graph[i, j];
      if weight = _INF then
        WriteF('%s'#9, [CHR])
      else
        WriteF('%d'#9, [weight]);
    end;
    WriteLn;
  end;

  DrawLineBlockEnd;
end;

procedure TPrim.__Prim;
var
  visited: TArr_bool;
  verxs, v1, v2, minWeight, i, j: integer;
begin
  SetLength(visited, _N);
  visited[1] := true;

  for verxs := 2 to _N - 1 do
  begin
    v1 := -1;
    v2 := -1;
    minWeight := _INF;

    for i := 1 to _N - 1 do
    begin
      for j := 1 to _N - 1 do
      begin
        if visited[i] and (not visited[j]) and (minWeight > _Graph[i, j]) then
        begin
          v1 := i;
          v2 := j;
          minWeight := _Graph[i, j];
        end;
      end;
    end;

    visited[v2] := true;
    _Res.AddLast(minWeight);

    WriteLnF('(%d -> %d: %d)', [v1, v2, minWeight]);
  end;

  DrawLineBlockEnd;
end;

end.
