// import 'package:test/test.dart';

// import '../src/node.dart';
// import '../src/parse.dart';

// void main() {
//   group("parseExpression()", () {
//     test(' fails on the empty string', () {
//       Parser parser = Parser('');

//       expect(
//         () => parser.parseExpression(), 
//         throwsRangeError
//       );
//     });
    
//     // unary operations
//     test(' fails when text[0] is followed by an invalid expression', () {
//       Parser parser = Parser('BW');

//       expect(
//         () => parser.parseExpression(),
//         throwsA(isA<AssertionError>())
//       );
//     });
//     test(' passes when text[0] is followed by a simple expression', () {
//       Parser parser = Parser('VZ');
      
//       Expression result = parser.parseExpression();
//       Expression expected = Invoke(Zilch());

//       expect(result, expected);
//       expect(parser.text, '');
//     });
//     test(' passes when text[0] is followed by a complex expression', () {
//       Parser parser = Parser('N1Q0');
      
//       Expression result = parser.parseExpression();
//       Expression expected = Not(Equal(Number(1), Number(0)));

//       expect(result, expected);
//       expect(parser.text, '');
//     });
//     test(' parses no more than the unary operation in front', () {
//       Parser parser = Parser('AZT');

//       Expression result = parser.parseExpression();
//       Expression expected = Access.unary(Zilch());

//       expect(result, expected);
//       expect(parser.text, 'T');
//     });
//   });
//   group("parseBinaryOperation()", () {
//     // removed
//   });
//   group("parseAccess()", () {
//     // removed
//   });
//   group("parseExpression()", () {
//     // TODO
//   });
//   group("parseGets()", () {
//     // TODO
//   });
//   group("parseStatement()", () {
//     // TODO
//   });
//   group("parseBlock()", () {
//     // TODO
//   });
//   group("parseProgram()", () {
//     // TODO
//   });

// //   test('empty string', () {
// //     String source = '';
    
// //     Node parsed = Node(NodeType.Program);
    
// //     expect(Parser(source).parseProgram(), parsed);
// //   });
// //   test('simple assignment', () {
// //     String source = 'ZGR';
    
// //     Node leftOperand = Node(NodeType.Zilch);
// //     Node rightOperand = Node(NodeType.Read);
// //     Node assignment = Node(NodeType.Gets);
// //     assignment.children!.addAll([rightOperand, leftOperand]);
// //     Node parsed = Node(NodeType.Program);
// //     parsed.children!.add(assignment);
    
// //     expect(Parser(source).parseProgram(), parsed);
// //   });
// //   test('empty class', () {
// //     String source = 'ZGCE';

// //     Node assignment = Node(NodeType.Gets);
// //     assignment.children!.addAll([Node(NodeType.Class), Node(NodeType.Zilch)]);
// //     Node parsed = Node(NodeType.Program);
// //     parsed.children!.add(assignment);

// //     expect(Parser(source).parseProgram(), parsed);
// //   });
// //   test('class with borrow', () {
// //     String source = 'ZGCBLE';

// //     Node borrow = Node(NodeType.Borrow);
// //     borrow.children!.add(Node(NodeType.Length));
// //     Node value = Node(NodeType.Class);
// //     value.altChildren = [borrow];
// //     Node assignment = Node(NodeType.Gets);
// //     assignment.children!.addAll([value, Node(NodeType.Zilch)]);
// //     Node parsed = Node(NodeType.Program);
// //     parsed.children!.add(assignment);

// //     expect(Parser(source).parseProgram(), parsed);
// //   });
// //   test('empty function', () {
// //     String source = 'MGFE';

// //     Node assignment = Node(NodeType.Gets);
// //     assignment.children!.addAll([Node(NodeType.Function), Node(NodeType.Main)]);
// //     Node parsed = Node(NodeType.Program);
// //     parsed.children!.add(assignment);

// //     expect(Parser(source).parseProgram(), parsed);
// //   });
// //   test('global access', () {
// //     String source = 'A0GZ';

// //     Node number = Node(NodeType.Number);
// //     number.value = 0;
// //     Node access = Node(NodeType.Access);
// //     access.children!.add(number);
// //     Node assignment = Node(NodeType.Gets);
// //     assignment.children!.addAll([Node(NodeType.Zilch), access]);
// //     Node parsed = Node(NodeType.Program);
// //     parsed.children!.add(assignment);

// //     expect(Parser(source).parseProgram(), parsed);
// //   });
// //   test('object access', () {
// //     String source = '1A0GZ';

// //     Node index = Node(NodeType.Number);
// //     index.value = 0;
// //     Node object = Node(NodeType.Number);
// //     object.value = 1;
// //     Node access = Node(NodeType.Access);
// //     access.children!.addAll([index, object]);
// //     Node assignment = Node(NodeType.Gets);
// //     assignment.children!.addAll([Node(NodeType.Zilch), access]);
// //     Node parsed = Node(NodeType.Program);
// //     parsed.children!.add(assignment);

// //     expect(Parser(source).parseProgram(), parsed);
// //   });
// //   test('during', () {
// //     String source = 'MGFDZTWREE';

// //     Node body = Node(NodeType.Write);
// //     body.children!.add(Node(NodeType.Read));
// //     Node during = Node(NodeType.During);
// //     during.condition = Node(NodeType.Zilch);
// //     during.children!.add(body);
// //     Node function = Node(NodeType.Function);
// //     function.children!.add(during);
// //     Node assignment = Node(NodeType.Gets);
// //     assignment.children!.addAll([function, Node(NodeType.Main)]);
// //     Node parsed = Node(NodeType.Program);
// //     parsed.children!.add(assignment);

// //     expect(Parser(source).parseProgram(), parsed);
// //   });
// //   test('if', () {
// //     String source = 'MGFILTO0EE';

// //     Node body = Node(NodeType.Throw);
// //     body.children!.add(Node(NodeType.Zilch));
// //     Node ifStatement = Node(NodeType.If);
// //     ifStatement.condition = Node(NodeType.Length);
// //     ifStatement.children!.add(body);
// //     Node function = Node(NodeType.Function);
// //     function.children!.add(ifStatement);
// //     Node assignment = Node(NodeType.Gets);
// //     assignment.children!.addAll([function, Node(NodeType.Main)]);
// //     Node parsed = Node(NodeType.Program);
// //     parsed.children!.add(assignment);

// //     expect(Parser(source).parseProgram(), parsed);
// //   });
// //   test('if/else', () {
// //     String source = 'MGFILTO0ENTKEE';

// //     Node body = Node(NodeType.Throw);
// //     body.children!.add(Node(NodeType.Zilch));
// //     Node ifStatement = Node(NodeType.If);
// //     ifStatement.condition = Node(NodeType.Length);
// //     ifStatement.children!.add(body);
// //     ifStatement.altChildren = [Node(NodeType.Break)];    
// //     Node function = Node(NodeType.Function);
// //     function.children!.add(ifStatement);
// //     Node assignment = Node(NodeType.Gets);
// //     assignment.children!.addAll([function, Node(NodeType.Main)]);
// //     Node parsed = Node(NodeType.Program);
// //     parsed.children!.add(assignment);

// //     expect(Parser(source).parseProgram(), parsed);
// //   });
// //   test('expect', () {
// //     String source = 'MGFXJ7HPE';

// //     Node body = Node(NodeType.Throw);
// //     body.children!.add(Node(NodeType.Zilch));
// //     Node ifStatement = Node(NodeType.If);
// //     ifStatement.condition = Node(NodeType.Length);
// //     ifStatement.children!.add(body);
// //     Node function = Node(NodeType.Function);
// //     function.children!.add(ifStatement);
// //     Node assignment = Node(NodeType.Gets);
// //     assignment.children!.addAll([function, Node(NodeType.Main)]);
// //     Node parsed = Node(NodeType.Program);
// //     parsed.children!.add(assignment);

// //     expect(Parser(source).parseProgram(), parsed);
// //   });
// //   test('simple binop', () {
// //     expect(false, true); // TODO
// //   });
// //   test('nested unop', () {
// //     expect(false, true); // TODO
// //   });
// //   test('nested binop', () {
// //     expect(false, true); // TODO
// //   });
// //   test('parentheses', () {
// //     expect(false, true); // TODO
// //   });
// //   test('complex expression', () {
// //     expect(false, true); // TODO
// //   });
// //   test('then separator', () {
// //     expect(false, true); // TODO
// //   });
// //   test('complex program', () {
// //     expect(false, true); // TODO
// //   });
// }