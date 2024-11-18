import 'package:test/test.dart';

import '../src/parse.dart';

void main() {
  test('empty string', () {
    String source = '';
    
    Node parsed = Node(NodeType.Program);
    
    expect(Parser(source).parseProgram(), parsed);
  });
  test('simple assignment', () {
    String source = 'ZGR';
    
    Node leftOperand = Node(NodeType.Zero);
    Node rightOperand = Node(NodeType.Read);
    Node assignment = Node(NodeType.Gets);
    assignment.children = [rightOperand, leftOperand];
    Node parsed = Node(NodeType.Program);
    parsed.children!.add(assignment);
    
    expect(Parser(source).parseProgram(), parsed);
  });
  test('empty class', () {
    String source = 'ZGCE';

    Node assignment = Node(NodeType.Gets);
    assignment.children = [Node(NodeType.Class), Node(NodeType.Zero)];
    Node parsed = Node(NodeType.Program);
    parsed.children!.add(assignment);

    expect(Parser(source).parseProgram(), parsed);
  });
  test('class with borrow', () {
    String source = 'ZGCBLE';

    Node borrow = Node(NodeType.Borrow);
    borrow.children!.add(Node(NodeType.Length));
    Node value = Node(NodeType.Class);
    value.altChildren = [borrow];
    Node assignment = Node(NodeType.Gets);
    assignment.children = [value, Node(NodeType.Zero)];
    Node parsed = Node(NodeType.Program);
    parsed.children!.add(assignment);

    expect(Parser(source).parseProgram(), parsed);
  });
  test('empty function', () {
    expect(false, true); // TODO
  });
  test('during', () {
    expect(false, true); // TODO
  });
  test('if', () {
    expect(false, true); // TODO
  });
  test('expect', () {
    expect(false, true); // TODO
  });
  test('then separator', () {
    expect(false, true); // TODO
  });
  test('simple unop', () {
    expect(false, true); // TODO
  });
  test('simple binop', () {
    expect(false, true); // TODO
  });
  test('nested unop', () {
    expect(false, true); // TODO
  });
  test('nested binop', () {
    expect(false, true); // TODO
  });
  test('parentheses', () {
    expect(false, true); // TODO
  });
  test('complex expression', () {
    expect(false, true); // TODO
  });
  test('complex program', () {
    expect(false, true); // TODO
  });
}