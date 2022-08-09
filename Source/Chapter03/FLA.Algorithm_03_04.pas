unit FLA.Algorithm_03_04;

{$mode delphiunicode}

interface

uses
  Classes,
  SysUtils,
  DeepStar.DSA.Linear.ArrayList,
  DeepStar.UString,
  DeepStar.Utils;

procedure Main;

implementation

type
  TADD = class(TObject)
  private
    _Nums1: TArrayList_int;
    _Nums2: TArrayList_int;
    _Sum: TArrayList_int;

    function __GetNum1: string;
    function __GetNum2: string;
    function __GetSum: string;

    // 逆序组合 List 到字符串
    function __NumToString(nums: TArrayList_int): string;
    // 将字符串逆序转换为 list
    procedure __StringToNumList(s: string; list: TArrayList_int);
    procedure __ADD(largerNums, smallerNums: TArrayList_int);

  public
    constructor Create;
    destructor Destroy; override;

    function ADD(num1, num2: string): string;

    property Num1: string read __GetNum1;
    property Num2: string read __GetNum2;
    property Sum: string read __GetSum;
  end;

  TMultiply = class(TObject)
  private type
    TArrayOfChar = array[0..999] of char;
    TArrayOfInteger = array[0..999] of integer;

    TNode = record
      Nums: TArrayOfInteger;
      Len: integer;
      Pow: integer;
      constructor Create(len, pow: integer);
    end;

  private
    _Nums1: TArrayOfChar;
    _Nums2: TArrayOfChar;
    _Sum: TArrayOfInteger;

    // 将一个 n 位的数分成两个 n/2 的数并存储，并记录它的次幂
    procedure __CP(var src, des: TNode; st, l: integer);
    // 逆序组合 List 到字符串
    function __NumToString(nums: TArrayOfInteger): string;
    // 将字符串逆序转换为 list
    procedure __StringToNumList(s: string; list: TArrayList_int);

    procedure __ADD(var pa, pb, ans: TNode);
    procedure __Mul(var pa, pb, ans: TNode);

  public
    constructor Create();
    destructor Destroy; override;
    function Multiply(num1, num2: string): string;
  end;

procedure Main;
var
  s: string;ss:TMultiply;
begin
  s := int64.MaxValue.ToString + int64.MaxValue.ToString;

  with TADD.Create do
  begin
    WriteLn(ADD(s, s));
    DrawLineBlockEnd;
    Free;
  end;

  ss := TMultiply.Create ;
  with ss do
  begin
    WriteLn(Multiply('12', '12'));
    Free;
  end;
end;

{ Tmultip }

constructor TMultiply.Create;
begin
  inherited Create;
end;

destructor TMultiply.Destroy;
begin
  inherited Destroy;
end;

function TMultiply.Multiply(num1, num2: string): string;
var
  a, b, ans: TNode;
begin
  __Mul(a, b, ans);
end;

procedure TMultiply.__ADD(var pa, pb, ans: TNode);
var
  i, cc, k, paLen, pbLen, len, ta, tb: integer;
  temp: TNode;
begin
  if pa.Pow < pb.Pow then
  begin
    temp := pa;
    pa := pb;
    pb := temp;
  end;

  ans.Pow := pb.Pow;
  cc := 0;
  paLen := pa.Len + pa.Pow;
  pbLen := pb.Len + pb.Pow;
  len := ifThen<integer>(paLen > pbLen, paLen, pbLen);

  if paLen > pbLen then
    len := paLen
  else
    len := pbLen;

  k := pa.Pow - pb.Pow;

  for i := 0 to len - ans.Pow do
  begin
    if i < k then
      ta := 0
    else
      ta := pa.Nums[i - k];

    if i < pb.len then
      tb := pb.Nums[i]
    else
      tb := 0;
    if i >= pa.Len + k then
      ta := 0;
    ans.Nums[i] := (ta + tb + cc) mod 10;
    cc := (ta + tb + cc) div 10;
  end;

  if cc <> 0 then
    ans.Nums[i] := cc;
  ans.Len := i;
end;

procedure TMultiply.__CP(var src, des: TNode; st, l: integer);
var
  i, j: integer;
begin
  i := st;
  j := 0;

  while i < st + l do
  begin
    des.Nums[j] := src.Nums[i];

    i += 1; j += 1;
  end;

  des.Len := l;
  des.Pow := st + src.Pow;
end;

procedure TMultiply.__Mul(var pa, pb, ans: TNode);
var
  i, cc, w, ma, mb: integer;
  ah, al, bh, bl, t1, t2, t3, t4, z, temp: TNode;
begin
  // 长度除2
  ma := pa.Len div 2;
  mb := pb.Len div 2;

  // 如果其中个数为1
  if (ma <> 0) or (mb <> 0) then
  begin
    if (ma <> 0) then
    begin
      temp := pa;
      pa := pb;
      pb := temp;
    end;

    ans.Pow := pa.Pow + pb.Pow;
    w := pb.Nums[0];
    cc := 0;

    for i := 0 to pa.Len do
    begin
      ans.Nums[i] := (w * pa.Nums[i] + cc) mod 10;
      cc := (w * pa.Nums[i] + cc) div 10;
    end;

    if (cc <> 0) then
    begin
      ans.Nums[i] := cc;
      i += 1;
    end;

    ans.Len := i;
    Exit;
  end;

  // 分治的核心
  // 先分成4部分 al, ah, bl, bh
  __CP(pa, ah, ma, pa.Len - ma);
  __CP(pa, al, 0, ma);
  __CP(pb, bh, mb, pb.Len - mb);
  __CP(pb, bl, 0, mb);

  __Mul(ah, bh, t1);
  __Mul(ah, bl, t2);
  __Mul(al, bh, t3);
  __Mul(al, bl, t4);

  __ADD(t3, t4, ans);
  __ADD(t2, ans, z);
  __ADD(t1, z, ans);
end;

function TMultiply.__NumToString(nums: TArrayOfInteger): string;
var
  sb: TStringBuilder;
  i: integer;
begin
  //if (nums = nil) or (nums.IsEmpty) then Exit('0');
  //
  //sb := TStringBuilder.Create;
  //try
  //  for i := nums.Count - 1 downto 0 do
  //    sb.Append(nums[i]);
  //
  //  Result := sb.ToString;
  //finally
  //  sb.Free;
  //end;
end;

procedure TMultiply.__StringToNumList(s: string; list: TArrayList_int);
var
  i: integer;
begin
  s := s.ReverseString;

  //for i := Low(s) to High(s) do
  //  list.AddLast(StrToInt(s[i]));
end;

{ Tmultip.TNode }

constructor TMultiply.TNode.Create(len, pow: integer);
begin
  Self.Len := len;
  Self.Pow := pow;
end;

{ TADD }

constructor TADD.Create;
begin
  _Nums1 := TArrayList_int.Create;
  _Nums2 := TArrayList_int.Create;
  _Sum := TArrayList_int.Create;
end;

function TADD.ADD(num1, num2: string): string;
begin
  _Nums1.Clear;
  _Nums2.Clear;
  _Sum.Clear;

  __StringToNumList(num1, _Nums1);
  __StringToNumList(num2, _Nums2);

  if _Nums1.Count >= _Nums2.Count then
    __ADD(_Nums1, _Nums2)
  else
    __ADD(_Nums2, _Nums1);

  Result := __NumToString(_Sum);
end;

destructor TADD.Destroy;
begin
  _Nums1.Free;
  _Nums2.Free;
  _Sum.Free;

  inherited Destroy;
end;

procedure TADD.__ADD(largerNums, smallerNums: TArrayList_int);
var
  a, b, i, j: integer;
  sd, td: integer; // sd: 个位; td:十位
begin
  i := 0;
  j := 0;

  while i < largerNums.Count do
  begin
    a := largerNums[i];
    if j < smallerNums.Count then
      b := smallerNums[j]
    else
      b := 0;

    if _Sum.Count > i then
    begin
      sd := (_Sum[i] + a + b) mod 10;
      td := (_Sum[i] + a + b) div 10;
      _Sum[i] := sd;
    end
    else
    begin
      sd := (a + b) mod 10;
      td := (a + b) div 10;
      _Sum.AddLast(sd);
    end;

    if td = 1 then _Sum.AddLast(td);

    i += 1;
    j += 1;
  end;
end;

function TADD.__GetNum1: string;
begin
  Result := __NumToString(_Nums1);
end;

function TADD.__GetNum2: string;
begin
  Result := __NumToString(_Nums2);
end;

function TADD.__GetSum: string;
begin
  Result := __NumToString(_Sum);
end;

function TADD.__NumToString(nums: TArrayList_int): string;
var
  sb: TStringBuilder;
  i: integer;
begin
  if (nums = nil) or (nums.IsEmpty) then Exit('0');

  sb := TStringBuilder.Create;
  try
    for i := nums.Count - 1 downto 0 do
      sb.Append(nums[i]);

    Result := sb.ToString;
  finally
    sb.Free;
  end;
end;

procedure TADD.__StringToNumList(s: string; list: TArrayList_int);
var
  i: integer;
begin
  s := s.ReverseString;

  for i := Low(s) to High(s) do
    list.AddLast(StrToInt(s[i]));
end;

end.
