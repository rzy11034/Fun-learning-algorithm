unit FLA.Algorithm_03_02;

//{$mode objfpc}{$H+}
//{$ModeSwitch unicodestrings}

{$mode delphiunicode}

interface

uses
  Classes,
  SysUtils,
  DeepStar.Utils;

procedure Main;

implementation

procedure MergeSort(var arr: TArr_int; l, r: integer);
  procedure __Merge__(var arr: TArr_int; l, mid, r: integer);
  var
    auxs: TArr_int;
    i, j, k: integer;
  begin
    SetLength(auxs, r - l + 1);
    i := l;
    j := mid + 1;
    k := 0;

    while (i <= mid) and (j <= r) do
    begin
      if arr[i] <= arr[j] then
      begin
        auxs[k] := arr[i];
        i += 1; k += 1;
      end
      else
      begin
        auxs[k] := arr[j];
        j += 1; k += 1;
      end;
    end;

    while i <= mid do
    begin
      auxs[k] := arr[i];
      i += 1; k += 1;
    end;

    while j <= r do
    begin
      auxs[k] := arr[j];
      j += 1; k += 1;
    end;

    for i := 0 to High(auxs) do
    begin
      arr[l] := auxs[i];
      l += 1;
    end;
  end;

var
  mid: integer;
begin
  if l >= r then Exit;

  mid := l + (r - l) div 2;
  MergeSort(arr, l, mid);
  MergeSort(arr, mid + 1, r);
  __Merge__(arr, l, mid, r);
end;

procedure Main;
var
  arr: TArr_int;
begin
  arr := [42, 15, 20, 6, 8, 38, 50, 12];

  TArrayUtils_int.Print(arr);
  MergeSort(arr, Low(arr), High(arr));
  TArrayUtils_int.Print(arr);
end;

end.
