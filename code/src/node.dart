abstract class Node {
  /// start of a node's starting token out of all tokens, starting at 1,
  /// regardless of if other tokens form their own nodes 
  /// or if they have length greater than 1
  /// 
  /// start 0 is reserved for the root [Program] node
  int start;
  /// number of tokens that compose the node, i.e.,
  /// [start] + [length] - 1 = start of final token of node
  int length;
  /// whether any of this node's descendants or the node itself are [Place]
  bool hasPlaceDescendant;
  Node(this.start, this.length, this.hasPlaceDescendant);
  @override bool operator ==(Object other) =>
    runtimeType == other.runtimeType &&
    start == (other as Node).start &&
    length == other.length
  ;
}

Map<Type, String> nodeTokens = {
  Access: 'A',
  Borrow: 'B',
  Copy: 'C',
  Defer: 'D',
  // End: 'E',
  Func: 'F',
  Gets: 'G',
  Catch: 'H',
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
  Wait: 'W',
  Examine: 'X',
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
  Expression(super.start, super.length, super.hasPlaceDescendant): assert(start != 0);
}

abstract class NullaryExpression extends Expression {
  NullaryExpression(int start) : super(start, 0, false);
  @override String toString() => nodeTokens[runtimeType]!;
}
class Main extends NullaryExpression {
  Main(super.start);
}
class Self extends NullaryExpression {
  Self(super.start);
}
class Zilch extends NullaryExpression {
  Zilch(super.start);
}
class Number extends NullaryExpression {
  int value;
  Number(super.start, {required this.value});
  @override String toString() => value.toString();
  @override bool operator ==(Object other) =>
    super == other && value == (other as Number).value
  ;
}

abstract class UnaryExpression extends Expression {
  Expression child;
  UnaryExpression(int start, this.child): super(start, 1 + child.length, child.hasPlaceDescendant);
  @override String toString() => "(${nodeTokens[runtimeType]} $child)";
  @override bool operator ==(Object other) =>
    super == other && this.child == (other as UnaryExpression).child
  ;
}
class Copy extends UnaryExpression {
  Copy(super.start, super.child);
}
class Length extends UnaryExpression {
  Length(super.start, super.child);
}
class Not extends UnaryExpression {
  Not(super.start, super.child);
}
class Read extends UnaryExpression {
  Read(super.start, super.child);
}
class Invoke extends UnaryExpression {
  Invoke(super.start, super.child);
}
class Wait extends UnaryExpression {
  Wait(super.start, super.child);
}
class Examine extends UnaryExpression {
  Examine(super.start, super.child);
} 

abstract class BinaryExpression extends Expression {
  Expression leftOperand;
  Expression rightOperand;
  BinaryExpression(start, this.leftOperand, this.rightOperand): super(start,
    leftOperand.length + 1 + rightOperand.length,
    leftOperand.hasPlaceDescendant || rightOperand.hasPlaceDescendant
  );
  @override bool operator ==(Object other) => 
    super == other && ((BinaryExpression binex) => 
      leftOperand == binex.leftOperand &&
      rightOperand == binex.rightOperand
    )(other as BinaryExpression)
  ;
  @override String toString() => "($leftOperand ${nodeTokens[runtimeType]} $rightOperand)";
}
class Equal extends BinaryExpression {
  Equal(super.start, super.leftOperand, super.rightOperand);
}
class Unless extends BinaryExpression {
  Unless(super.start, super.leftOperand, super.rightOperand);
}

abstract class OptionallyBinaryExpression extends Expression {
  Expression? leftOperand;
  Expression rightOperand;
  OptionallyBinaryExpression(start, this.rightOperand, [this.leftOperand]): super(start,
    (leftOperand?.length ?? 0) + 1 + rightOperand.length,
    (leftOperand?.hasPlaceDescendant ?? false) || rightOperand.hasPlaceDescendant
  );
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
  Access(super.start, super.rightOperand, [super.leftOperand]);
}
class Borrow extends OptionallyBinaryExpression {
  Borrow(super.start, super.rightOperand, [super.leftOperand]);
}

class Link extends Expression {
  List<Expression> children;
  Link(start, this.children):
    assert(children.length >= 2, "cannot link fewer than 2 items"),
    super(start,
      children.map((child) => child.length).reduce((a, b) => a + 1 + b),
      children.map((child) => child.hasPlaceDescendant).reduce((a, b) => a || b)
    )
  ;
  @override bool operator ==(Object other) => 
    super == other && 
    compareLists(this.children, (other as Link).children)
  ;
  @override String toString() => "(${this.children.join(" K ")})";
}

class Func extends Expression {
  List<Statement> children;
  Func(start, this.children): super(start,
    children.map((child) => child.length).reduce((a, b) => a + b) + 2,
    children.map((child) => child.hasPlaceDescendant).reduce((a, b) => a || b)
  );
  @override bool operator ==(Object other) =>
    super == other &&
    compareLists(this.children, (other as Func).children)
  ;
  @override String toString() => "F {${children.map((child) => child.toString()).join(" ")}} E";
}

// statements
abstract class Statement extends Node {
  Statement(super.start, super.length, super.hasPlaceDescendant): assert(start != 0);
}

abstract class NullaryStatement extends Statement {
  NullaryStatement(start, hasPlaceDescendant): super(start, 1, hasPlaceDescendant);
  @override String toString() => "${nodeTokens[runtimeType]};";
}
class Place extends NullaryStatement {
  Place(start): super(start, true);
}

abstract class UnaryStatement extends Statement {
  Expression child;
  UnaryStatement(start, this.child):
    super(start, 1 + child.length, false)
  ;
  @override bool operator ==(Object other) => 
    super == other && child == (other as UnaryStatement).child
  ;
  @override String toString() => "${nodeTokens[runtimeType]!} ${child.toString()};";
}
class Jump extends UnaryStatement {
  Jump(super.start, super.child);
}
class Throw extends UnaryStatement {
  Throw(super.start, super.child);
}
class Yield extends UnaryStatement {
  Yield(super.start, super.child);
}

abstract class BinaryStatement extends Statement {
  Expression leftChild;
  Expression rightChild;
  BinaryStatement(start, this.leftChild, this.rightChild):
    super(start, leftChild.length + 1 + rightChild.length, false)
  ;
  @override bool operator ==(Object other) => 
    super == other && ((Gets gets) =>
      this.leftChild == gets.leftChild &&
      this.rightChild == gets.rightChild
    )(other as Gets)
  ;
  @override String toString() => "${leftChild.toString()} ${super.toString()} ${rightChild.toString()};";
}
class Gets extends BinaryStatement {
  Gets(super.start, super.leftChild, super.rightChild);
}

abstract class ConditionalStatement extends Statement {
  Expression condition;
  List<Statement> children;
  ConditionalStatement(start, this.condition, this.children): super(start,
    condition.length + children.map((child) => child.length).reduce((a, b) => a + b) + 3,
    children.map((child) => child.hasPlaceDescendant).reduce((a, b) => a || b)
  );
  @override bool operator ==(Object other) => 
    super == other && ((ConditionalStatement during) =>
      condition == during.condition &&
      compareLists(children, during.children)
    )(other as ConditionalStatement)
  ;
  @override String toString() =>
    "${nodeTokens[runtimeType]} $condition T {${this.children.join(" ")}} E"
  ;
}
class Defer extends ConditionalStatement {
  Defer(start, awaitedBlock, callbackBlock): super(start, awaitedBlock, callbackBlock);
}
class If extends ConditionalStatement {
  List<Statement>? elseChildren;
  If(start, condition, children, [this.elseChildren]): super(start, condition, children) {
    if (elseChildren != null) 
      length += elseChildren!.map((child) => child.length).reduce((a, b) => a + b) + 3
    ;
    hasPlaceDescendant |= 
      elseChildren?.map((child) => child.hasPlaceDescendant).reduce((a, b) => a || b) ?? false
    ;
  }
  @override bool operator ==(Object other) => 
    super == other && ((If ifStatement) =>
      (elseChildren == null) == (ifStatement.elseChildren == null) &&
      compareLists(elseChildren ?? [], ifStatement.elseChildren ?? [])
    )(other as If)
  ;
  @override String toString() => 
    "${super.toString()}"
    "${elseChildren == null ? '' : " NT {${elseChildren!.join(" ")}} E"}"
  ;
}

abstract class ReactiveStatement extends Statement {
  List<Statement> action;
  List<Statement> reaction;
  ReactiveStatement(start, this.action, this.reaction): super(start,
    (
      action.map((child) => child.length).reduce((a, b) => a + b) +
      reaction.map((child) => child.length).reduce((a, b) => a + b) + 3
    ), (
      action.map((child) => child.hasPlaceDescendant).reduce((a, b) => a || b) ||
      reaction.map((child) => child.hasPlaceDescendant).reduce((a, b) => a || b)
    )
  );
  @override bool operator ==(Object other) => 
    super == other && ((ReactiveStatement rs) =>
      compareLists(action, rs.action) &&
      compareLists(reaction, rs.reaction)
    )(other as ReactiveStatement)
  ;
  @override String toString() =>
    "${nodeTokens[runtimeType]} {${action.join(" ")}} T {${reaction.join(" ")}} E"
  ;
}
class Catch extends ReactiveStatement {
  Catch(start, tryBlock, catchBlock): super(start, tryBlock, catchBlock);
}

// program
class Program extends Node {
  List<Statement> children;
  Program(start, this.children): super(start,
    children.map((child) => child.length).reduce((a, b) => a + b),
    children.map((child) => child.hasPlaceDescendant).reduce((a, b) => a || b)
  );
  @override bool operator ==(Object other) =>
    super == other &&
    compareLists(this.children, (other as Program).children)
  ;
  @override String toString() => this.children.join(" ");
}
