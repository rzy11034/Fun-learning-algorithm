unit FLA.Algorithm_03_03;

{$mode objfpc}{$H+}
{$ModeSwitch unicodestrings}

interface

uses
  Classes,
  SysUtils,
  DeepStar.Utils;

procedure Main;

implementation

function Checked(const a: TArr_int): boolean;
var
  i: integer;
begin
  Result := true;

  for i := 1 to High(a) do
    if a[i - 1] > a[i] then
    begin
      Result := false;
      Exit;
    end;
end;

procedure Swap(var arr: TArr_int; i, j: integer);
var
  temp: integer;
begin
  temp := arr[i];
  arr[i] := arr[j];
  arr[j] := temp;
end;

procedure QuickSort_OneWay(arr: TArr_int);
var
  Count: integer = 0;

  function __Partition_(a: TArr_int; l, r: integer): integer;
  var
    i, j, pivot: integer;
  begin
    i := l;
    j := r;
    pivot := a[l];

    while i < j do
    begin
      while (i < j) and (pivot < a[j]) do j -= 1;
      if i < j then
      begin
        Swap(a, i, j);
        i += 1;
      end;

      while (i < j) and (pivot >= a[i]) do i += 1;
      if i < j then
      begin
        Swap(a, i, j);
        j -= 1;
      end;
    end;

    Result := i;
  end;

  procedure __QuickSort__(var a: TArr_int; l, r: integer);
  var
    mid: integer;
  begin
    if l >= r then Exit;

    Count += 1;

    mid := __Partition_(a, l, r);
    __QuickSort__(a, l, mid - 1);
    __QuickSort__(a, mid + 1, r);
  end;

var
  a: TArr_int;
begin
  a := Copy(arr);
  __QuickSort__(a, Low(a), High(a));

  writelnF('QuickSort_OneWay: count = %d, Check = %s', [Count, BoolToStr(Checked(a), true)]);
  //TArrayUtils_int.Print(a);
  DrawLineBlockEnd;
end;

procedure Qiucksort_TwoWay(arr: TArr_int);
var
  Count: integer = 0;

  function __Partition__(var a: TArr_int; l, r: integer): integer;
  var
    i, j, pivot: integer;
  begin
    i := l;
    j := r;
    pivot := a[l];

    while i < j do
    begin
      while (i < j) and (a[j] > pivot) do j -= 1;
      while (i < j) and (a[i] <= pivot) do i += 1;

      if i < j then Swap(a, i, j);
    end;

    if a[i] > pivot then
    begin
      Swap(a, i - 1, l);
      Exit(i - 1);
    end;

    Swap(a, l, i);
    Result := i;
  end;

  procedure __QuickSort__(var a: TArr_int; l, r: integer);
  var
    mid: integer;
  begin
    if l >= r then Exit;

    Count += 1;

    mid := __Partition__(a, l, r);
    __QuickSort__(a, l, mid - 1);
    __QuickSort__(a, mid + 1, r);
  end;

var
  a: TArr_int;
begin
  a := Copy(arr);
  __QuickSort__(a, Low(a), High(a));
  writelnF('Qiucksort_TwoWay: count = %d, Check = %s', [Count, BoolToStr(Checked(a), true)]);
  //TArrayUtils_int.Print(a);
  DrawLineBlockEnd;
end;

procedure g(var arr: TArr_int; n: integer);
var
  i: integer;
begin
  SetLength(arr, n);

  for i := 0 to High(arr) do
    arr[i] := Random(n);
end;

procedure Main;
var
  arr: TArr_int;
begin
   //arr:=[30,24,5,58,18,36,12,42,39];
  g(arr, 1000);

  QuickSort_OneWay(arr);
  Qiucksort_TwoWay(arr);
end;

end.
