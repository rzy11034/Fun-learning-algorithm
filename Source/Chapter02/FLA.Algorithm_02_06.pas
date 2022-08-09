unit FLA.Algorithm_02_06;

{$mode ObjFPC}{$H+}
{$ModeSwitch advancedrecords}
{$ModeSwitch unicodestrings}

interface

uses
  Classes,
  SysUtils,
  DeepStar.DSA.Hash.HashMap,
  DeepStar.DSA.Interfaces,
  DeepStar.DSA.Tree.PriorityQueue,
  DeepStar.UString;

procedure Main;

implementation

type
  TWeightNode = record
    Character: char;
    Weight: double;
  end;

const
  WeightNodes: array of TWeightNode = (
    (Character: 'a'; Weight: 0.05),
    (Character: 'b'; Weight: 0.32),
    (Character: 'c'; Weight: 0.18),
    (Character: 'd'; Weight: 0.07),
    (Character: 'e'; Weight: 0.25),
    (Character: 'f'; Weight: 0.13));

  n = 6;

{ TODO -orzy -c书上用例 : 此段代码未通过 }
{$REGION '书上用例'}
procedure HuffmanTreeCode_List();
const
  MAXBIT = 100;
  MaxValue = 10000;
  MAXLEAF = 30;
  MAXNODE = MAXLEAF * 2 - 1;
type
  THNodeType = record
    Weight: double; // 权值
    Parent: integer; // 双亲
    Lchild: integer; // 左孩子
    Rchild: integer; // 右孩子
    Value: char; // 该节点表示的字符
  end;
  TBits = array[0..MAXBIT] of integer;
  { 编码结构体 }
  THCordType = record
    Bit: TBits; // 存储编码的数组
    Start: integer; // 编码开始下标
  end;
  TArr_THNodeType = array[0..MAXNODE] of THNodeType;
  TArr_THCodetype = array[0..MAXLEAF] of THCordType;
var
  huffNode: TArr_THNodeType; // 定义一个结点结构体数组
  {%H-}huffCode: TArr_THCodetype; // 定义一个编码结构体数组

  procedure HuffmanTree(n: integer);
  var
    i, j: integer;
    m1, m2: double; // 构造哈扒曼树不同过程中两个最小权值结点的权值
    x1, x2: integer; // 构造哈扒曼树不同过程中两个最小权值结点在数组中的序号
  begin
    // 初始化存放哈夫曼树数组 HuffNode[] 中的结点
    i := 0;
    while i < 2 * n - 1 do
    begin
      huffNode[i].Weight := 0; // 权值
      huffNode[i].Lchild := -1;
      huffNode[i].Rchild := -1;
      huffNode[i].Parent := -1;

      i += 1;
    end;

    // 输入 n 个叶子结点的权值
    for i := 0 to n - 1 do
    begin
      huffNode[i].Value := WeightNodes[i].Character;
      huffNode[i].Weight := WeightNodes[i].Weight;
    end;

    // 构造 Huffman 树
    i := 0;
    while i < n - 1 do
    begin
      // 执行 n －1 次合并
      m1 := MaxValue;
      m2 := MaxValue;

      // m1, m2 中存放两所无父结点且结点权值最小的两个结点
      x1 := 0;
      x2 := 0;

      // 找出所有结点中有值最小、无父结点的两个结点， 并合并之为一棵二叉树
      j := 0;
      while j < n + i do
      begin
        if (HuffNode[j].Weight < m1) and (HuffNode[j].Parent = -1) then
        begin
          m2 := m1;
          x2 := x1;
          m1 := HuffNode[j].Weight;
          x1 := j;
        end
        else if (HuffNode[j].Weight < m2) and (HuffNode[j].Parent = -1) then
        begin
          m2 := HuffNode[j].Weight;
          x2 := j;
        end;

        j += 1;
      end;

      // 设置找到的两个子结点 x1、x2 的父结点信息
      HuffNode[x1].Parent := n + 1;
      HuffNode[x2].Parent := n + 1;
      HuffNode[n + i].Weight := m1 + m2;
      HuffNode[n + i].LChild := x1;

      WriteLn('x1.weight and x2.weight in round ', i + 1, #9);

      i += 1;
    end;
  end;

  // 哈夫曼树编码
  procedure HuffmanCode(n: integer);
  var
    cd: THCordType;
    p, i, c, j: integer;
  begin
    for i := 0 to n - 1 do
    begin
      cd.Start := n - 1;
      c := i;
      p := HuffNode[c].Parent;

      while p <> -1 do
      begin
        if HuffNode[p].LChild = c then
          cd.Bit[cd.Start] := 0
        else
          cd.Bit[cd.Start] := 1;

        cd.Start -= 1; // 求编码的低一位
        c := p;
        p := huffNode[c].Parent; // 设置下一循环条件
      end;

      // 把叶子结点的编码信息从临时编码 cd 中复制出来，放入编码结构体数组
      for j := 0 to n - 1 do
        huffCode[i].Bit[j] := cd.Bit[j];

      huffCode[i].Start := cd.Start;
    end;
  end;

begin
  HuffmanTree(n);
  HuffmanCode(n);
end;

{$ENDREGION}

type
  THuffmanTreeCode_BinaryTree = class(TObject)
  private type
    PHNodeType = ^THNodeType;
    THNodeType = record
      Weight: double; // 权值
      Parent: PHNodeType; // 双亲
      Lchild: PHNodeType; // 左孩子
      Rchild: PHNodeType; // 右孩子
      Value: char; // 该节点表示的字符

      constructor Create(newWeight: double; newParent: PHNodeType;
        newLchild: PHNodeType; newRchild: PHNodeType; newValue: char);
      class function Comparer(constref a, b: PHNodeType): integer; static;
      function ToString: string;
    end;

    TQueue_PHnodeType = specialize TPriorityQueue<PHNodeType>;
    TMap_char_str = specialize THashMap<char, string>;

  public type

    IMap_char_str = specialize IMap<char, string>;

  private
    _CodeMap: IMap_char_str;
    _N: integer;
    _Root: PHNodeType;

    function __GetHuffmanTree: PHNodeType;
    procedure __GetHuffmanCode(node: PHNodeType; s: string);
    procedure __FreeHNode(node: PHNodeType);

  public
    constructor Create(n: integer);
    destructor Destroy; override;

    property CodeMap: IMap_char_str read _CodeMap;
  end;

type
  Tpair = THuffmanTreeCode_BinaryTree.TMap_char_str.TPair;
  TPQ = specialize TPriorityQueue<Tpair>;

function Comparer(constref a, b: Tpair): integer;
begin
  Result := Ord(a.Key) - Ord(b.Key);
end;

procedure Run_THuffmanTreeCode_BinaryTree();
var
  h: THuffmanTreeCode_BinaryTree;
  pair: Tpair;
  pq: TPQ;
  icmp: TPQ.ICmp;
begin
  h := THuffmanTreeCode_BinaryTree.Create(n);
  try
    icmp := TPQ.TCmp.Construct(TPQ.TImpl.TComparisonFuncs(@Comparer));
    pq := TPQ.Create(icmp);
    try
      for pair in (h.CodeMap as h.TMap_char_str).Pairs do
        pq.EnQueue(pair);


      while not pq.IsEmpty do
      begin
        pair := pq.DeQueue;
        WriteLn(pair.Key, ', ', pair.Value);
      end;
    finally
      pq.Free;
    end;

  finally
    h.Free;
  end;
end;

procedure Main;
begin
  Run_THuffmanTreeCode_BinaryTree;
end;

{ THuffmanTreeCode_BinaryTree.THNodeType }

constructor THuffmanTreeCode_BinaryTree.THNodeType.Create(
  newWeight: double; newParent: PHNodeType; newLchild: PHNodeType;
  newRchild: PHNodeType; newValue: char);
begin
  with Self do
  begin
    Weight := newWeight; // 权值
    Parent := newParent; // 双亲
    Lchild := newLchild; // 左孩子
    Rchild := newRchild; // 右孩子
    Value := newValue; // 该节点表示的字符
  end;
end;

class function THuffmanTreeCode_BinaryTree.THNodeType.Comparer(
  constref a, b: PHNodeType): integer;
begin
  Result := 0;

  if a^.Weight - b^.Weight > 0 then
    Result := 1
  else
    Result := -1;
end;

function THuffmanTreeCode_BinaryTree.THNodeType.ToString: string;
var
  sb: TUnicodeStringBuilder;
begin
  sb := TStringBuilder.Create();
  try
    sb.AppendFormat('(%c, %s)', [Self.Value, Self.Weight]);
    Result := sb.ToString;
  finally
    sb.Free;
  end;
end;

{ THuffmanTreeCode_BinaryTree }

constructor THuffmanTreeCode_BinaryTree.Create(n: integer);
begin
  Self._N := n;
  _Root := __GetHuffmanTree;
  _CodeMap := TMap_char_str.Create(n);
  __GetHuffmanCode(_Root, '');
end;

destructor THuffmanTreeCode_BinaryTree.Destroy;
begin
  __FreeHNode(_Root);
  inherited Destroy;
end;

procedure THuffmanTreeCode_BinaryTree.__FreeHNode(node: PHNodeType);
begin
  if node = nil then Exit;

  __FreeHNode(node^.Lchild);
  __FreeHNode(node^.Rchild);

  Dispose(node);
end;

procedure THuffmanTreeCode_BinaryTree.__GetHuffmanCode(node: PHNodeType; s: string);
var
  res: string = '';
begin
  if node = nil then Exit;

  res += s;

  if node^.Value = #0 then
  begin
    __GetHuffmanCode(node^.Lchild, res + '0');
    __GetHuffmanCode(node^.Rchild, res + '1');
  end
  else
  begin
    _CodeMap.Add(node^.Value, res);
  end;
end;

function THuffmanTreeCode_BinaryTree.__GetHuffmanTree: PHNodeType;
var
  queue: TQueue_PHnodeType;
  i: integer;
  parent, p1, p2: PHNodeType;
  c: char;
  w: double;
begin
  queue := TQueue_PHnodeType.Create(
    THuffmanTreeCode_BinaryTree.TQueue_PHnodeType.TCmp.Construct(
    @THuffmanTreeCode_BinaryTree.THNodeType.Comparer));
  try
    for i := 0 to High(WeightNodes) do
    begin
      new(parent);
      //parent^ := Default(THNodeType);

      c := WeightNodes[i].Character;
      w := WeightNodes[i].Weight;
      parent^ := THNodeType.Create(w, nil, nil, nil, c);

      queue.EnQueue(parent);
    end;

    i := queue.Count;
    while i > 1 do
    begin
      p1 := queue.DeQueue;
      p2 := queue.DeQueue;

      w := p1^.Weight + p2^.Weight;
      new(parent);
      if THNodeType.Comparer(p1, p2) < 0 then
        parent^ := THNodeType.Create(w, nil, p1, p2, #0)
      else
        parent^ := THNodeType.Create(w, nil, p2, p1, #0);

      queue.EnQueue(parent);

      i := queue.Count;
    end;

    Result := queue.DeQueue;
  finally
    queue.Free;
  end;
end;

end.
