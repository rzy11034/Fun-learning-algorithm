unit FLA.Algorithm_02_03;

{$mode objfpc}{$H+}
{$ModeSwitch advancedrecords}

interface

uses
  Classes,
  SysUtils,
  DeepStar.Utils;

procedure Main;

implementation

type
  TMeet = record
    Start: integer; // 会议开始时间
    Finish: integer;  // 会议结束时间
    Num: integer;  // 会议的编号
    class function cmp(constref left, right: TMeet): integer; static;
    class function Create(newNum, newStart, newFinish: integer): TMeet; static;
  end;

  TSetMeet = class
  private
    _Last: integer;
    _N: integer; // 会议总数
    _Ans: integer; // 会议最大安排数
    _Meet: array of TMeet;

    procedure __PrintMeet;
  public
    constructor Create();
    procedure Solve;

  end;


procedure Main;
var
  setMeet: TSetMeet;
begin
  setMeet := TSetMeet.Create;
  try
    setMeet.Solve;
  finally
    setMeet.Free;
  end;
end;

{ TSetMeet }

constructor TSetMeet.Create;
begin
  _N := 10;

  SetLength(_Meet, _N);
  _Meet := [
    TMeet.Create(1, 3, 6),
    TMeet.Create(2, 1, 4),
    TMeet.Create(3, 5, 7),
    TMeet.Create(4, 2, 5),
    TMeet.Create(5, 5, 9),
    TMeet.Create(6, 3, 8),
    TMeet.Create(7, 8, 11),
    TMeet.Create(8, 6, 10),
    TMeet.Create(9, 8, 12),
    TMeet.Create(10, 12, 14)];

  _Ans := 0;
  _Last := 0;
end;

procedure TSetMeet.__PrintMeet;
var
  i: integer;
begin
  WriteLnF('%s%16s%16s', ['会议编号', '会议开始时间', '会议结束' + '时间']);

  for i := 0 to High(_Meet) do
  begin
    WriteF('%4d%16d%16d', [_Meet[i].Num, _Meet[i].Start, _Meet[i].Finish]);
    WriteLn;
  end;
end;

procedure TSetMeet.Solve;
type
  TArrayUtils_TMeet = specialize TArrayUtils<TMeet>;
var
  i: integer;
begin
  WriteLn('排序前的会议时间安排是：');
  __PrintMeet;

  DrawLineBlockEnd;

  TArrayUtils_TMeet.Sort(_Meet, @TMeet.cmp);

  WriteLn('排序后的会议时间安排是：');
  __PrintMeet;

  DrawLineBlockEnd;

  _Ans := 0; // 用来记录可以安排会议的个数
  _Last := 0; // last记录会议的结束时间

  for i := 0 to High(_Meet) do // 依次检查每个会议
  begin
    // 如果会议 i 开始时间大于等于最后一个选中的会议的结束时间
    if _Meet[i].Start >= _Last then
    begin
      _Last := _Meet[i].Finish; // 更新last为最后一个选中会议的结束时间
      _Ans += 1; // 返回可以安排的会议最大数
      WriteLnF('选择了第%d个会议', [_Meet[i].Num]);
    end;
  end;

  WriteLnF('最多可以安排%d个会议。', [_Ans]);
end;

{ TMeet }

class function TMeet.cmp(constref left, right: TMeet): integer;
var
  res: integer;
begin
  res := left.Finish - right.Finish;

  if res = 0 then
    res := right.Start - left.Start;

  Result := res;
end;

class function TMeet.Create(newNum, newStart, newFinish: integer): TMeet;
begin
  Result.Start := newStart;
  Result.Finish := newFinish;
  Result.Num := newNum;
end;

end.
