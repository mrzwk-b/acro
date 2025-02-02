abstract class Node {
  /// position of a node's token out of all tokens, starting at 1,
  /// regardless of if other tokens form their own nodes 
  /// or if they have length greater than 1
  /// 
  /// for example, the code "D 10 T P E" contains the following tokens at the following positions:
  /// 
  /// 1: D
  /// 
  /// 2: 10
  /// 
  /// 3: T
  /// 
  /// 4: P
  /// 
  /// 5: E
  /// 
  /// position 0 is reserved for the root [Program] node
  int position;
  Node(this.position);
  @override bool operator ==(Object other) =>
    runtimeType == other.runtimeType &&
    position == (other as Node).position
  ;
}

Map<Type, String> nodeTokens = {
  Access: 'A',
  Borrow: 'B',
  Copy: 'C',
  During: 'D',
  // End: 'E',
  Func: 'F',
  Gets: 'G',
  // Catch: 'H',
  If: 'I',
  Jump: 'J',
  Link: 'K',
  Length: 'L',
  Main: 'M',
  Not: 'N',
  Throw: 'O',
  Place: 'P',
  Equal: 'Q',
  Read: 'R',
  Self: 'S',
  // Then: 'T',
  Unless: 'U',
  Invoke: 'V',
  Await: 'W',
  Expect: 'X',
  Yield: 'Y',
  Zilch: 'Z',
};

bool compareLists (List x, List y) {
  if (x.length != y.length) {
    return false;
  }
  for (int i = 0; i < x.length; i++) {
    if (x[i] != y[i]) {
      return false;
    }
  }
  return true;
}

// expressions
abstract class Expression extends Node {
  Expression(super.position);
}

abstract class NullaryExpression extends Expression {
  NullaryExpression(super.position);
  @override String toString() => nodeTokens[runtimeType]!;
}
class Main extends NullaryExpression {
  Main(super.position);
}
class Self extends NullaryExpression {
  Self(super.position);
}
class Zilch extends NullaryExpression {
  Zilch(super.position);
}
class Number extends NullaryExpression {
  int value;
  Number(super.position, {required this.value});
  @override String toString() => value.toString();
  @override bool operator ==(Object other) =>
    super == other && value == (other as Number).value
  ;
}

abstract class UnaryExpression extends Expression {
  Expression child;
  UnaryExpression(super.position, this.child);
  @override String toString() => "(${nodeTokens[runtimeType]} $child)";
  @override bool operator ==(Object other) =>
    super == other && this.child == (other as UnaryExpression).child
  ;
}
class Copy extends UnaryExpression {
  Copy(super.position, super.child);
}
class Length extends UnaryExpression {
  Length(super.position, super.child);
}
class Not extends UnaryExpression {
  Not(super.position, super.child);
}
class Read extends UnaryExpression {
  Read(super.position, super.child);
}
class Invoke extends UnaryExpression {
  Invoke(super.position, super.child);
}

abstract class BinaryExpression extends Expression {
  Expression leftOperand;
  Expression rightOperand;
  BinaryExpression(super.position, this.leftOperand, this.rightOperand);

  @override bool operator ==(Object other) => 
    super == other && ((BinaryExpression binex) => 
      leftOperand == binex.leftOperand &&
      rightOperand == binex.rightOperand
    )(other as BinaryExpression)
  ;
  @override String toString() => "($leftOperand ${nodeTokens[runtimeType]} $rightOperand)";
}
class Equal extends BinaryExpression {
  Equal(super.position, super.leftOperand, super.rightOperand);
}
class Unless extends BinaryExpression {
  Unless(super.position, super.leftOperand, super.rightOperand);
}

abstract class OptionallyBinaryExpression extends Expression {
  Expression? leftOperand;
  Expression rightOperand;
  OptionallyBinaryExpression(super.position, Expression x, [Expression? y]): 
    leftOperand = y == null ? y : x,
    rightOperand = y == null ? x : y
  ;

  @override bool operator ==(Object other) => 
    super == other && ((OptionallyBinaryExpression opbinex) =>
      this.leftOperand == opbinex.leftOperand &&
      this.rightOperand == opbinex.rightOperand
    )(other as OptionallyBinaryExpression)
  ;
  @override String toString() => 
    "(${leftOperand == null ? "" : "$leftOperand "}${nodeTokens[runtimeType]} ${rightOperand})"
  ;
}
class Access extends OptionallyBinaryExpression {
  Access(super.position, super.x, [super.y]);
}
class Borrow extends OptionallyBinaryExpression {
  Borrow(super.position, super.x, [super.y]);
}

class Link extends Expression {
  List<Expression> children;
  Link(super.position, this.children);
  @override bool operator ==(Object other) => 
    super == other && 
    compareLists(this.children, (other as Link).children)
  ;
  @override String toString() => "(${this.children.join(" K ")})";
}

// statements
abstract class Statement extends Node {
  Statement(super.position);
}

class Place extends Statement {
  Place(super.position);
}

abstract class UnaryStatement extends Statement {
  Expression child;
  UnaryStatement(super.position, this.child);
  @override bool operator ==(Object other) => 
    super == other && child == (other as UnaryStatement).child
  ;
  @override String toString() => "${nodeTokens[runtimeType]!} ${child.toString()};";
}
class Jump extends UnaryStatement {
  Jump(super.position, super.child);
}
class Throw extends UnaryStatement {
  Throw(super.position, super.child);
}
class Yield extends UnaryStatement {
  Yield(super.position, super.child);
}

abstract class BinaryStatement extends Statement {
  Expression leftChild;
  Expression rightChild;
  BinaryStatement(super.position, this.leftChild, this.rightChild);
  @override bool operator ==(Object other) => 
    super == other && ((Gets gets) =>
      this.leftChild == gets.leftChild &&
      this.rightChild == gets.rightChild
    )(other as Gets)
  ;
  @override String toString() => "${leftChild.toString()} ${super.toString()} ${rightChild.toString()};";
}
class Gets extends BinaryStatement {
  Gets(super.position, super.leftChild, super.rightChild);
}

abstract class Block extends Node {
  List<Statement> children;
  Block(super.position, this.children);

  @override bool operator ==(Object other) =>
    super == other &&
    compareLists(this.children, (other as Block).children)
  ;
  @override String toString() => this.children.join(" ");
}
class Program extends Block {
  Program(super.position, super.children);
}
class Func extends Block implements Expression {
  Func(super.position, super.children);
  @override String toString() => "F ${super.toString()} E";
}

class During extends Statement {
  Expression condition;
  List<Statement> children;
  During(super.position, this.condition, this.children);

  @override bool operator ==(Object other) => 
    super == other && ((During during) =>
      condition == during.condition &&
      compareLists(children, during.children)
    )(other as During)
  ;
  @override String toString() => "D $condition T ${this.children.join(" ")} E";
}
class If extends Statement {
  Expression condition;
  List<Statement> children;
  List<Statement>? elseChildren;
  If(super.position, this.condition, this.children, [this.elseChildren]);

  @override bool operator ==(Object other) => 
    super == other && ((If ifStatement) =>
      condition == ifStatement.condition &&
      compareLists(children, ifStatement.children) && 
      (elseChildren == null) == (ifStatement.elseChildren == null) &&
      compareLists(elseChildren ?? [], ifStatement.elseChildren ?? [])
    )(other as If)
  ;
  @override String toString() => 
    "I $condition T ${this.children.join(" ")} E"
    "${elseChildren == null ? '' : " NT ${elseChildren!.join(" ")} E"}"
  ;
}
class Expect extends Statement {
  List<Statement> tryChildren;
  List<Statement> catchChildren;
  Expect(super.position, this.tryChildren, this.catchChildren);
  @override bool operator ==(Object other) => 
    super == other && ((Expect expect) =>
      compareLists(tryChildren, expect.tryChildren) && 
      compareLists(catchChildren, expect.catchChildren)
    )(other as Expect)
  ;
  @override String toString() => "X ${tryChildren.join(" ")} H ${catchChildren.join(" ")} E";
}
class Await extends Statement {
  List<Statement> asyncChildren;
  List<Statement> callbackChildren;
  Await(super.position, this.asyncChildren, this.callbackChildren);
  @override bool operator ==(Object other) =>
    super == other && ((Await awaitStatement) =>
      compareLists(asyncChildren, awaitStatement.asyncChildren) &&
      compareLists(callbackChildren, awaitStatement.callbackChildren)
    )(other as Await)
  ;
  @override String toString() => "W ${asyncChildren.join(" ")} T ${callbackChildren.join(" ")} E";
}

class Error implements Expression, Statement {
  // TODO consider deleting
  get position => this.position;
  set position(int position) {this.position = position;}
}
