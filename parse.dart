Set legalCharacters = {
  'A','B','C','D','E','F','G','H','I','J','K','L','M',
  'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
  '0','1','2','3','4','5','6','7','8','9','(',')',
};

enum NodeType {
  Program,
  Number,
  Error,

  Access,
  Borrow,
  Class,
  During,
  // End,
  Function,
  Gets,
  // Catch,
  If,
  Jump,
  Break,
  Length,
  Main,
  Not,
  Throw,
  Repeat,
  Equal,
  Read,
  Self,
  // Then,
  Unless,
  Invoke,
  Write,
  Expect,
  Yield,
  Zero
}

class Node {
  NodeType type;
  List<Node>? children;
  Node? condition;
  List<Node>? altChildren;
  int? value;

  Node(this.type) {
    children = {
      NodeType.Length, NodeType.Read, NodeType.Self, NodeType.Zero, NodeType.Number
    }.contains(type) ? null : [];
    altChildren = {NodeType.If, NodeType.Expect}.contains(type) ? [] : null;
  }
}

class Parser {
  String text;

  Parser(this.text);

  /// deletes all nonfunctional characters from the front of [text]
  void trim() {
    while (!legalCharacters.contains(text[0])) {
      text = text.substring(1);
    }
  }

 
  // parsing methods

  /// returns a Node of [type] with a parsed expression from head of [text] in [children]
  /// 
  /// advances head of [text] past operand
  Node parseUnaryOperation(NodeType type) {
    Node operation = Node(type);

    text = text.substring(1);
    trim();

    operation.children!.add(parseExpression());
    return operation;
  }

  /// with [type] and [rightOperand] from head of [text]:
  /// - returns a Node of [type] with [rightOperand] and [leftOperand] in [children]
  /// 
  /// advances head of [text] past operand
  Node parseBinaryOperation(Node leftOperand) {
    Node expression;
    if (text[0] == "A") {
      expression = Node(NodeType.Access);
    }
    else if (text[0] == "G") {
      expression = Node(NodeType.Gets);
    }
    else if (text[0] == "Q") {
      expression = Node(NodeType.Equal);
    }
    else if (text[0] == "U") {
      expression = Node(NodeType.Unless);
    }
    else {
      assert(false, "Expected binary operator, found '${text[0]}'");
      expression = Node(NodeType.Error);
    }
    text = text.substring(1);
    trim();

    expression.children!.addAll([parseExpression(), leftOperand]);
    return expression;
  }

  /// parses an expression of any [type] from head of [text]
  /// 
  /// advances head of [text] to after expression
  Node parseExpression() {
    Node expression;
    bool parenthesized = text[0] == '(';
    if (parenthesized) {
      text = text.substring(1);
      trim();
    }

    // numbers
    if (int.tryParse(text[0]) != null) {
      expression = Node(NodeType.Number);
      String value = '';
      while (int.tryParse(text[0]) != null) {
        value += text[0];
        text = text.substring(1);
        trim();
      }
      expression.value = int.parse(value);
    }

    // special constructs
    else if (text[0] == 'C') {
      expression = Node(NodeType.Class);
      text = text.substring(1);
      
      trim();
      if (text[0] == 'B') {        
        expression.altChildren = [parseUnaryOperation(NodeType.Borrow)];

        trim();
        assert(text[0] == "T", "Expected 'T' to close 'B', found '${text[0]}'");
        text = text.substring(1);
      }

      trim();
      expression.children = parseBlock(getsOnly: true);
    }
    else if (text[0] == 'F') {
      text = text.substring(1);
      expression = Node(NodeType.Function);
      expression.children = parseBlock();
    }

    // nullary operations
    else if (text[0] == 'L') {
      expression = Node(NodeType.Length);
      text = text.substring(1);
    }
    else if (text[0] == 'R') {
      expression = Node(NodeType.Read);
      text = text.substring(1);
    }
    else if (text[0] == 'S') {
      expression = Node(NodeType.Self);
      text = text.substring(1);
    }
    else if (text[0] == 'Z') {
      expression = Node(NodeType.Zero);
      text = text.substring(1);
    }

    // unary operations
    else if (text[0] == 'B') {
      expression = parseUnaryOperation(NodeType.Borrow);
    }
    else if (text[0] == 'A') {
      expression = parseUnaryOperation(NodeType.Access);
    }
    else if (text[0] == 'N') {
      expression = parseUnaryOperation(NodeType.Not);
    }
    else if (text[0] == 'V') {
      expression = parseUnaryOperation(NodeType.Invoke);
    }

    // binary operations
    else {
      Node leftOperand = parseExpression();
      trim();
      expression = parseBinaryOperation(leftOperand);
    }

    trim();
    if (parenthesized) {
      assert(text[0] == ')', "Expected closing paren, found '${text[0]}'");
      text = text.substring(1);
    }
    return expression;
  }

  Node parseGets() {
    Node leftOperand = parseExpression();

    trim();
    return parseBinaryOperation(leftOperand);
  }

  /// parses a statement of any [type] from head of [text]
  /// 
  /// advances head of [text] to after statement
  Node parseStatement() {
    Node statement;
    // no argument
    if (text[0] == 'D') {
      statement = Node(NodeType.During);
      text = text.substring(1);

      trim();
      statement.condition = parseExpression();

      trim();
      assert(text.startsWith('T'), "Expected 'T' after condition of 'D', found '${text[0]}'");
      text = text.substring(1);

      trim();
      statement.children = parseBlock();
    }
    else if (text[0] == 'I') {
      statement = Node(NodeType.If);
      text = text.substring(1);

      trim();
      statement.condition = parseExpression();

      trim();
      assert(text.startsWith('T'), "Expected 'T' after condition of 'I', found '${text[0]}'");
      text = text.substring(1);

      trim();
      statement.children = parseBlock();

      trim();
      if (text.startsWith('NT')) {
        text = text.substring(2);
        statement.altChildren = parseBlock();
      }
    }
    else if (text[0] == 'T') {
      text = text.substring(1);
      statement = Node(NodeType.Zero);
    }
    else if (text[0] == 'X') {
      statement = Node(NodeType.Expect);
      text = text.substring(1);
      
      trim();
      statement.children = parseBlock(terminator: 'H');

      trim();
      statement.condition = parseExpression();
      
      trim();
      assert(text.startsWith('T'), "Expected 'T' to start 'H' block, found '${text[0]}'");
      text = text.substring(1);

      trim();
      statement.altChildren = parseBlock();
    }
    // with argument
    else if (text[0] == 'J') {
      statement = parseUnaryOperation(NodeType.Jump);
    }
    else if (text[0] == 'O') {
      statement = parseUnaryOperation(NodeType.Throw);
    }
    else if (text[0] == 'V') {
      statement = parseUnaryOperation(NodeType.Invoke);
    }
    else if (text[0] == 'W') {
      statement = parseUnaryOperation(NodeType.Write);
    }
    else if (text[0] == 'Y') {
      statement = parseUnaryOperation(NodeType.Yield);
    }
    else {
      statement = parseGets();
    }
    return statement;
  }

  /// parses a block of statements from head of [text]
  /// (requiring block's header token to be out of the way already)
  /// 
  /// returns a list of [Node]s in the block
  ///
  /// advances head of [text] past [terminator]
  List<Node> parseBlock({bool getsOnly = false, String terminator = 'E'}) {
    List<Node> block = [];
    
    while (text[0] != terminator){
      block.add(getsOnly ? parseGets() : parseStatement());
      trim();
    }
    text = text.substring(1);

    return block;
  }

  Node parseProgram() {
    Node program = Node(NodeType.Program);

    while (text.length != 0) {
      trim();
      program.children!.add(parseGets());
    }

    return program;
  }
}
