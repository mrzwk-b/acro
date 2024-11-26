// import 'package:test/test.dart';

// import '../src/node.dart';
// import '../src/parse.dart';

// void main() {
//   group("parseExpression()", () {
//     test('empty string', () {
//       Parser parser = Parser('');
//       expect(() => parser.parseExpression(), throwsRangeError);
//     });
//     test('invalid expression', () {
//       Parser parser = Parser('WZ');
//       expect(() => parser.parseExpression(), throwsA(isA<AssertionError>()));
//     });
//     test("nullary expression", () {
//       Parser parser = Parser('L');
//       expect(parser.parseExpression(), Length());
//       parser = Parser('R');
//       expect(parser.parseExpression(), Read());
//       parser = Parser('S');
//       expect(parser.parseExpression(), Self());
//       parser = Parser('Z');
//       expect(parser.parseExpression(), Zilch());
//       parser = Parser('365');
//       expect(parser.parseExpression(), Number(365));
//     });
//     test('unary expression', () {
//       Parser parser = Parser('AZ');
//       expect(parser.parseExpression(), Access(Zilch()));
//       parser = Parser('BZ');
//       expect(parser.parseExpression(), Borrow(Zilch()));
//       parser = Parser('NZ');
//       expect(parser.parseExpression(), Not(Zilch()));
//       parser = Parser('VZ');
//       expect(parser.parseExpression(), Invoke(Zilch()));

//       // nested
//       parser = Parser('ABNVZ');
//       expect(parser.parseExpression(), Access(Borrow(Not(Invoke(Zilch())))));
//     });
//     test("binary expression", () {
//       Parser parser = Parser("LAR");
//       expect(parser.parseExpression(), Access(Length(), Read()));
//       parser = Parser("LBR");
//       expect(parser.parseExpression(), Borrow(Length(), Read()));
//       parser = Parser("LQR");
//       expect(parser.parseExpression(), Equal(Length(), Read()));
//       parser = Parser("LUR");
//       expect(parser.parseExpression(), Unless(Length(), Read()));
//     });
//     test("unparenthesized", () {
//       Parser parser = Parser("N1Q0");
//       expect(parser.parseExpression(), Not(Equal(Number(1), Number(0))));
//       parser = Parser("LQ0UR");
//       expect(parser.parseExpression(), Equal(Length(), Unless(Number(0), Read())));
//     });
//     test("parentheses", () {
//       Parser parser = Parser("(N1)Q0");
//       expect(parser.parseExpression(), Equal(Not(Number(1)), Number(0)));
//       parser = Parser("(LQ0)UR");
//       expect(parser.parseExpression(), Unless(Equal(Length(), Number(0)), Read()));
//     });
//     test("nonfunctional characters", () {
//       Parser parser = Parser("(?LoremQips0m)dolU_R sit");
//       expect(parser.parseExpression(), Unless(Equal(Length(), Number(0)), Read()));
//     });
//     test('effect on [text]', () {
//       Parser parser = Parser('AZT');
//       expect(parser.parseExpression(), Access(Zilch()));
//       expect(parser.text, 'T');
//     });
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