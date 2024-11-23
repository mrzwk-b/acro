abstract class Node {}
class Error implements Expression, Statement {}

Map<Type, String> nodeTokens = {
  Access: 'A',
  Borrow: 'B',
  Class: 'C',
  During: 'D',
  // End: 'E',
  Func: 'F',
  Gets: 'G',
  // Catch: 'H',
  If: 'I',
  Jump: 'J',
  Break: 'K',
  Length: 'L',
  Main: 'M',
  Not: 'N',
  Throw: 'O',
  Repeat: 'P',
  Equal: 'Q',
  Read: 'R',
  Self: 'S',
  // Then: 'T',
  Unless: 'U',
  Invoke: 'V',
  Write: 'W',
  Expect: 'X',
  Yield: 'Y',
  Zilch: 'Z',
};

// expressions
abstract class Expression extends Node {}

abstract class NullaryExpression extends Expression {
  @override String toString() => nodeTokens[runtimeType]!;
}
class Length extends NullaryExpression {
  @override bool operator ==(Object other) => other is Length;
}
class Main extends NullaryExpression {
  @override bool operator ==(Object other) => other is Main;
}
class Read extends NullaryExpression {
  @override bool operator ==(Object other) => other is Read;
}
class Self extends NullaryExpression {
  @override bool operator ==(Object other) => other is Self;
}
class Zilch extends NullaryExpression {
  @override bool operator ==(Object other) => other is Zilch;
}
class Number extends NullaryExpression {
  int value;
  Number(this.value);
  @override String toString() => value.toString();
  @override bool operator ==(Object other) => other is Number && this.value == other.value;
}

abstract class UnaryExpression extends Expression {
  Expression child;
  UnaryExpression(this.child);
  @override String toString() => "(${nodeTokens[runtimeType]} $child)";
  @override bool operator ==(Object other) => other is UnaryExpression && this.child == other.child;
}
class Not extends UnaryExpression {
  Not(super.child);
  @override bool operator ==(Object other) => (super == other) && other is Not;
}
class Invoke extends UnaryExpression {
  Invoke(super.child);
  @override bool operator ==(Object other) => (super == other) && other is Invoke;
}

abstract class BinaryExpression extends Expression {
  Expression leftOperand;
  Expression rightOperand;
  BinaryExpression(this.leftOperand, this.rightOperand);

  @override bool operator ==(Object other) => 
    other is BinaryExpression &&
    this.leftOperand == other.leftOperand &&
    this.rightOperand == other.rightOperand
  ;
  @override String toString() => "($leftOperand ${nodeTokens[runtimeType]} $rightOperand)";
}
class Equal extends BinaryExpression {
  Equal(super.leftOperand, super.rightOperand);
  @override bool operator ==(Object other) => (super == other) && other is Equal;
}
class Unless extends BinaryExpression {
  Unless(super.leftOperand, super.rightOperand);
  @override bool operator ==(Object other) => (super == other) && other is Unless;
}

abstract class OptionallyBinaryExpression extends Expression {
  Expression? leftOperand;
  Expression rightOperand;
  OptionallyBinaryExpression(Expression x, [Expression? y]): 
    leftOperand = y == null ? y : x,
    rightOperand = y == null ? x : y
  ;

  @override bool operator ==(Object other) => 
    other is OptionallyBinaryExpression && 
    this.leftOperand == other.leftOperand &&
    this.rightOperand == other.rightOperand
  ;
  @override String toString() => 
    "(${leftOperand == null ? "" : "$leftOperand "}${nodeTokens[runtimeType]} ${rightOperand})"
  ;
}
class Access extends OptionallyBinaryExpression {
  Access(super.x, [super.y]);
  @override bool operator ==(Object other) => (super == other) && other is Access;
}
class Borrow extends OptionallyBinaryExpression {
  Borrow(super.x, [super.y]);
  @override bool operator ==(Object other) => (super == other) && other is Borrow;
}

// statements
abstract class Statement extends Node {}

abstract class NullaryStatement extends Statement {
  @override String toString() => "${nodeTokens[runtimeType]!};";
}
class Jump extends NullaryStatement {
  @override bool operator ==(Object other) => other is Jump;
}
class Break extends NullaryStatement {
  @override bool operator ==(Object other) => other is Break;
}
class Repeat extends NullaryStatement {
  @override bool operator ==(Object other) => other is Repeat;
}

abstract class UnaryStatement extends Statement {
  Expression child;
  UnaryStatement(this.child);
  @override bool operator ==(Object other) => 
    other is UnaryStatement && this.child == other.child
  ;
  @override String toString() => "${nodeTokens[runtimeType]!} ${child.toString()};";
}
class Throw extends UnaryStatement {
  Throw(super.child);
  @override bool operator ==(Object other) => (super == other) && other is Throw;
}
class Write extends UnaryStatement {
  Write(super.child);
  @override bool operator ==(Object other) => (super == other) && other is Write;
}
class Yield extends UnaryStatement {
  Yield(super.child);
  @override bool operator ==(Object other) => (super == other) && other is Yield;
}

class Gets extends Statement {
  Access leftChild;
  Expression rightChild;
  Gets(this.leftChild, this.rightChild);
  @override bool operator ==(Object other) => 
    other is Gets && 
    this.leftChild == other.leftChild &&
    this.rightChild == other.rightChild
  ;
  @override
  String toString() => '${leftChild.toString()} G ${rightChild.toString()};';
}

// multiline elements
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

abstract class Block extends Node {
  List<Statement> children;
  Block(this.children);

  @override bool operator ==(Object other) =>
    other is Block &&
    compareLists(this.children, other.children)
  ;
  @override String toString() => this.children.join(" ")
  ;
}
class Program extends Block {
  Program(super.children);
  @override operator ==(Object other) => (super == other) && other is Program;
}
class Func extends Block implements Expression {
  Func(super.children);
  @override operator ==(Object other) => (super == other) && other is Func;
  @override String toString() => "F ${super.toString()} E";
}
class Class extends Block implements Expression{
  Borrow? borrow;
  Class(super.children, [this.borrow]);
  @override operator ==(Object other) => (super == other) && other is Class;
  @override String toString() => "C${borrow == null ? "" : " $borrow T"} ${super.toString()} E";
}

class During extends Statement {
  Expression condition;
  List<Statement> children;
  During(this.condition, this.children);

  @override bool operator ==(Object other) => 
    other is During &&
    this.condition == other.condition &&
    compareLists(this.children, other.children)
  ;
  @override String toString() => "D $condition T ${this.children.join(" ")} E";
}
class If extends Statement {
  Expression condition;
  List<Statement> children;
  List<Statement>? elseChildren;
  If(this.condition, this.children, [this.elseChildren]);

  @override bool operator ==(Object other) => 
    other is If &&
    this.condition == other.condition &&
    compareLists(this.children, other.children) && 
    (
      (
        this.elseChildren != null && 
        other.elseChildren != null &&
        compareLists(this.elseChildren!, other.elseChildren!)
      ) || (
        this.elseChildren == null &&
        other.elseChildren == null
      )
    )
  ;
  @override String toString() => 
    "I $condition T ${this.children.join(" ")} E"
    "${elseChildren == null ? '' : " NT ${elseChildren!.join(" ")} E"}"
  ;
}
class Expect extends Statement {
  List<Statement> tryChildren;
  List<Statement> catchChildren;
  Expect(this.tryChildren, this.catchChildren);

  @override bool operator ==(Object other) => 
    other is Expect &&
    compareLists(this.tryChildren, other.tryChildren) && 
    compareLists(this.catchChildren, other.catchChildren)
  ;
  @override String toString() => "X ${this.tryChildren.join(" ")} H ${catchChildren.join(" ")} E";
}
