import 'node.dart';

Set<String> legalCharacters = {
  'A','B','C','D','E','F','G','H','I','J','K','L','M',
  'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
  '0','1','2','3','4','5','6','7','8','9','(',')',
};

class Parser {
  String text;

  Parser(this.text);

  /// deletes all nonfunctional characters from the front of [text]
  void trim() {
    while (text.length > 0 && !legalCharacters.contains(text[0])) {
      text = text.substring(1);
    }
  }

  // parsing methods

  /// parses an expression of any [type] from head of [text]
  /// 
  /// advances head of [text] to after expression
  Expression parseExpression() {
    Expression expression;
    bool parenthesized = text[0] == '(';
    if (parenthesized) {
      text = text.substring(1);
      trim();
    }

    // numbers
    if (int.tryParse(text[0]) != null) {
      String value = '';
      while (text != '' && int.tryParse(text[0]) != null) {
        value += text[0];
        text = text.substring(1);
        trim();
      }
      expression = Number(int.parse(value));
    }

    // special constructs
    else if (text[0] == 'C') {
      text = text.substring(1);
      
      trim();
      Borrow? borrow;
      if (text[0] == 'B') {
        borrow = Borrow(parseExpression());

        trim();
        assert(text[0] == "T", "Expected 'T' to close 'B', found '${text[0]}'");
        text = text.substring(1);
      }

      trim();
      expression = Class(parseBlock(), borrow);
    }
    else if (text[0] == 'F') {
      text = text.substring(1);
      trim();
      expression = Func(parseBlock());
    }

    // nullary operations
    else if (text[0] == 'L') {
      text = text.substring(1);
      expression = Length();
    }
    else if (text[0] == 'R') {
      text = text.substring(1);
      expression = Read();
    }
    else if (text[0] == 'S') {
      text = text.substring(1);
      expression = Self();
    }
    else if (text[0] == 'Z') {
      text = text.substring(1);
      expression = Zilch();
    }

    // unary operations
    else if (text[0] == 'A') {
      text = text.substring(1);
      trim();
      expression = Access(parseExpression());
    }
    else if (text[0] == 'B') {
      text = text.substring(1);
      trim();
      expression = Borrow(parseExpression());
    }
    else if (text[0] == 'N') {
      text = text.substring(1);
      trim();
      expression = Not(parseExpression());
    }
    else if (text[0] == 'V') {
      text = text.substring(1);
      trim();
      expression = Invoke(parseExpression());
    }
    else {
      assert(false, "Expected valid expression starter, found ${text[0]}");
      expression = Error();
    }

    // binary operations
    trim();
    if ({'A','B','Q','U'}.contains(text.length == 0 ? '' : text[0])) {
      if (text[0] == "A") {
        text = text.substring(1);
        trim();
        expression = Access(expression, parseExpression());
      }
      else if (text[0] == "B") {
        text = text.substring(1);
        trim();
        expression = Borrow(expression, parseExpression());
      }
      else if (text[0] == "Q") {
        text = text.substring(1);
        trim();
        expression = Equal(expression, parseExpression());
      }
      else if (text[0] == "U") {
        text = text.substring(1);
        trim();
        expression = Unless(expression, parseExpression());
      }
      else {
        assert(false, "Expected binary operator, found '${text[0]}'");
        expression = Error();
      }
    }

    trim();
    if (parenthesized) {
      if (text.startsWith(')')) {
        text = text.substring(1);
        return expression;
      }
      else {
        assert(false, "Expected closing paren, found '${text[0]}'");
      }
    }
    return expression;
  }

  Gets parseGets() {
    Expression leftChild = parseExpression();
    assert(leftChild is Access, "Expected access expression, found ${leftChild.runtimeType}");

    trim();
    assert(text.startsWith('G'), "Expected 'G', found ${text[0]}");
    text = text.substring(1);

    trim();
    return Gets(leftChild as Access, parseExpression());
  }

  /// parses a statement of any [type] from head of [text]
  /// 
  /// advances head of [text] to after statement
  Statement? parseStatement() {
    Statement? statement;
    // conditional
    if (text[0] == 'D') {
      text = text.substring(1);

      trim();
      Expression condition = parseExpression();

      trim();
      assert(text.startsWith('T'), "Expected 'T' after condition of 'D', found '${text[0]}'");
      text = text.substring(1);

      trim();
      List<Statement> children = parseBlock();

      statement = During(condition, children);
    }
    else if (text[0] == 'I') {
      text = text.substring(1);

      trim();
      Expression condition = parseExpression();

      trim();
      assert(text.startsWith('T'), "Expected 'T' after condition of 'I', found '${text[0]}'");
      text = text.substring(1);

      trim();
      List<Statement> children = parseBlock();

      trim();
      List<Statement>? elseChildren;
      if (text.startsWith('N')) {
        text = text.substring(1);
        
        trim();
        if (text.startsWith('T')) {
          elseChildren = parseBlock();
        }
        else {
          text = 'N' + text;
        }
      }
      statement = If(condition, children, elseChildren);
    }
    else if (text[0] == 'X') {
      text = text.substring(1);
      
      trim();
      List<Statement> tryChildren = parseBlock(terminator: 'H');

      trim();
      List<Statement> catchChildren = parseBlock();

      statement = Expect(tryChildren, catchChildren);
    }
    // simple
    else if (text[0] == 'T') {
      text = text.substring(1);
    }
    else if (text[0] == 'J') {
      text = text.substring(1);
      statement = Jump();
    }
    else if (text[0] == 'K') {
      text = text.substring(1);
      statement = Break();
    }
    // parameterized
    else if (text[0] == 'O') {
      text = text.substring(1);
      trim(); 
      statement = Throw(parseExpression());
    }
    else if (text[0] == 'W') {
      text = text.substring(1);
      trim(); 
      statement = Write(parseExpression());
    }
    else if (text[0] == 'Y') {
      text = text.substring(1);
      trim(); 
      statement = Yield(parseExpression());
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
  List<Statement> parseBlock({bool getsOnly = false, String terminator = 'E'}) {
    List<Statement> block = [];
    
    while (text[0] != terminator){
      Statement? statement = getsOnly ? parseGets() : parseStatement();
      if (statement != null) {
        block.add(statement);
      }
      trim();
    }
    text = text.substring(1);

    return block;
  }

  Program parseProgram() => Program(parseBlock());
}
