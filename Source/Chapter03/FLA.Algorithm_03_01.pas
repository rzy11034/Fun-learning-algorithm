unit FLA.Algorithm_03_01;

{$mode ObjFPC}{$H+}
{$ModeSwitch unicodestrings}
{$ModeSwitch advancedrecords}

interface

uses
  Classes,
  SysUtils,
  DeepStar.Utils;

procedure Main;

implementation

// 迭代法
function BinarySearch_Iteration(arr: TArr_int; f: integer): integer;
var
  l, r, mid: integer;
begin
  Result := -1;

  l := Low(arr);
  r := High(arr);

  while l < r do
  begin
    mid := l + (r - l) div 2;

    if f < arr[mid] then
      r := mid
    else if f > arr[mid] then
      l := mid + 1
    else
      Exit(mid + 1);
  end;
end;

// 递归法
function BinarySearch_Recurtion(arr: TArr_int; f: integer): integer;
  function __BS__(l, r: integer): integer;
  var
    mid: integer;
  begin
    if l >= r then Exit(-1);

    mid := l + (r - 1) div 2;
    if f < arr[mid] then
      Result := __BS__(l, mid)
    else if f > arr[mid] then
      Result := __BS__(mid + 1, r)
    else
      Exit(mid + 1);
  end;

begin
  Result := __BS__(Low(arr), High(arr));
end;

procedure Main;
var
  sl: TStringList;
  nums: TArr_int;
  i: integer;
begin
  sl := TStringList.Create;
  try
    sl.AddDelimitedtext('60 17 39 15 8 34 30 45 5 52 25');

    SetLength(nums, sl.Count);
    for i := 0 to sl.Count - 1 do
      nums[i] := sl[i].ToInteger;
  finally
    sl.Free;
  end;

  TArrayUtils_int.Sort(nums);
  TArrayUtils_int.Print(nums);
  WriteLnF('迭代法查找的元素17在第%d位.', [BinarySearch_Iteration(nums, 18)]);
  WriteLnF('递归法查找的元素17在第%d位.', [BinarySearch_Recurtion(nums, 18)]);
end;

end.
