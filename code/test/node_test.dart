import 'dart:ffi';
import 'package:test/test.dart';
import '../src/node.dart';

// test toString, length, hasPlaceDescendant, and == implementation
// for all instantiable Node subclasses

void main() {
  group("NullaryExpression: ", () {
    test("Main", () {
      Main m = Main(1);
      expect(m, Main(1));
      expect(m, isNot(Main(2)));
      expect(m, isNot(Self(1)));
      expect(m.length, 1);
      expect(m.hasPlaceDescendant, false);
      expect(m.toString(), 'M');
    });
    test("Self", () {
      Self s = Self(1);
      expect(s, Self(1));
      expect(s, isNot(Self(2)));
      expect(s, isNot(Zilch(1)));
      expect(s.length, 1);
      expect(s.hasPlaceDescendant, false);
      expect(s.toString(), 'S');
    });
    test("Zilch", () {
      Zilch z = Zilch(1);
      expect(z, Zilch(1));
      expect(z, isNot(Zilch(2)));
      expect(z, isNot(Number(1, value: 0)));
      expect(z.length, 1);
      expect(z.hasPlaceDescendant, false);
      expect(z.toString(), 'Z');
    });
    test("Number", () {
      Number one = Number(1, value: 1);
      expect(one, Number(1, value: 1));
      expect(one, isNot(Number(1, value: 0)));
      expect(one, isNot(Number(2, value: 1)));
      expect(one, isNot(Self(1)));
      expect(one.length, 1);
      expect(one.hasPlaceDescendant, false);
      expect(one.toString(), '1');
    });
  });
  group("UnaryExpression: ", () {
    test("Copy", () {
      Copy c = Copy(1, Main(2));
      expect(c, Copy(1, Main(2)));
      expect(c, isNot(Copy(3, Main(2))));
      expect(c, isNot(Copy(1, Main(3))));
      expect(c, isNot(Copy(1, Self(2))));
      expect(c, isNot(Length(1, Main(2))));
      expect(c.length, 2);
      expect(c.hasPlaceDescendant, false);
      expect(c.toString(), "(C M)");
    });
    test("Length", () {
      Length l = Length(1, Self(2));
      expect(l, Length(1, Self(2)));
      expect(l, isNot(Length(3, Self(2))));
      expect(l, isNot(Length(1, Self(3))));
      expect(l, isNot(Length(1, Zilch(2))));
      expect(l, isNot(Read(1, Self(2))));
      expect(l.length, 2);
      expect(l.hasPlaceDescendant, false);
      expect(l.toString(), "(L S)");
    });
    test("Read", () {
      Read r = Read(1, Self(2));
      expect(r, Read(1, Self(2)));
      expect(r, isNot(Read(3, Self(2))));
      expect(r, isNot(Read(1, Self(3))));
      expect(r, isNot(Read(1, Zilch(2))));
      expect(r, isNot(Not(1, Self(2))));
      expect(r.length, 2);
      expect(r.hasPlaceDescendant, false);
      expect(r.toString(), "(R S)");
    });
    test("Not", () {
      Not n = Not(1, Zilch(2));
      expect(n, Not(1, Zilch(2)));
      expect(n, isNot(Not(3, Zilch(2))));
      expect(n, isNot(Not(1, Zilch(3))));
      expect(n, isNot(Not(1, Main(2))));
      expect(n, isNot(Invoke(1, Zilch(2))));
      expect(n.length, 2);
      expect(n.hasPlaceDescendant, false);
      expect(n.toString(), "(N Z)");
    });
    test("inVoke", () {
      Invoke v = Invoke(1, Main(2));
      expect(v, Invoke(1, Main(2)));
      expect(v, isNot(Invoke(3, Main(2))));
      expect(v, isNot(Invoke(1, Main(3))));
      expect(v, isNot(Invoke(1, Self(2))));
      expect(v, isNot(Wait(1, Main(2))));
      expect(v.length, 2);
      expect(v.hasPlaceDescendant, false);
      expect(v.toString(), "(V M)");
    });
    test("Wait", () {
      Wait w = Wait(1, Self(2));
      expect(w, Wait(1, Self(2)));
      expect(w, isNot(Wait(3, Self(2))));
      expect(w, isNot(Wait(1, Self(3))));
      expect(w, isNot(Wait(1, Zilch(2))));
      expect(w, isNot(Examine(1, Self(2))));
      expect(w.length, 2);
      expect(w.hasPlaceDescendant, false);
      expect(w.toString(), "(W S)");
    });
    test("eXamine", () {
      Examine x = Examine(1, Zilch(2));
      expect(x, Examine(1, Zilch(2)));
      expect(x, isNot(Examine(3, Zilch(2))));
      expect(x, isNot(Examine(1, Zilch(3))));
      expect(x, isNot(Examine(1, Main(2))));
      expect(x, isNot(Copy(1, Zilch(2))));
      expect(x.length, 2);
      expect(x.hasPlaceDescendant, false);
      expect(x.toString(), "(X Z)");
    });
    test("nested", () {
      UnaryExpression e = Length(1, Copy(2, Not(3, Invoke(4, Zilch(5)))));
      expect(e, Length(1, Copy(2, Not(3, Invoke(4, Zilch(5))))));
      expect(e, isNot(Length(6, Copy(2, Not(3, Invoke(4, Zilch(5)))))));
      expect(e, isNot(Length(1, Copy(6, Not(3, Invoke(4, Zilch(5)))))));
      expect(e, isNot(Length(1, Copy(2, Not(6, Invoke(4, Zilch(5)))))));
      expect(e, isNot(Length(1, Copy(2, Not(3, Invoke(6, Zilch(5)))))));
      expect(e, isNot(Length(1, Copy(2, Not(3, Invoke(4, Zilch(6)))))));
      expect(e, isNot(Not(1, Copy(2, Not(3, Invoke(4, Zilch(5)))))));
      expect(e, isNot(Length(1, Invoke(2, Not(3, Invoke(4, Zilch(5)))))));
      expect(e, isNot(Length(1, Copy(2, Length(3, Invoke(4, Zilch(5)))))));
      expect(e, isNot(Length(1, Copy(2, Not(3, Copy(4, Zilch(5)))))));
      expect(e, isNot(Length(1, Copy(2, Not(3, Invoke(4, Self(5)))))));
      expect(e.length, 5);
      expect(e.child.length, 4);
      expect((e.child as UnaryExpression).child.length, 3);
      expect(((e.child as UnaryExpression).child as UnaryExpression).child.length, 2);
      expect(
        (((e.child as UnaryExpression).child as UnaryExpression).child as UnaryExpression).child.length,
        1
      );
      expect(e.hasPlaceDescendant, false);
      expect(e.toString(), "(L (C (N (V Z))))");
    });
    test("hasPlaceDescendant", () {
      UnaryExpression yes = Copy(1, Func(2, [Place(3)]));
      expect(yes.hasPlaceDescendant, true);
    });
  });
  group("BinaryExpression: ", () {
    test("eQual", () {
      Equal q = Equal(1, Zilch(1), Self(3));
      expect(q, Equal(1, Zilch(1), Self(3)));
      expect(q, isNot(Equal(1, Zilch(1), Self(3))));
      expect(q, isNot(Equal(1, Zilch(4), Self(3))));
      expect(q, isNot(Equal(1, Zilch(1), Self(4))));
      expect(q, isNot(Equal(1, Main(1), Self(3))));
      expect(q, isNot(Equal(1, Zilch(1), Main(3))));
      expect(q, isNot(Unless(1, Zilch(1), Self(3))));
      expect(q.length, 3);
      expect(q.hasPlaceDescendant, false);
      expect(q.toString(), "(Z Q S)");
    });
    test("Unless", () {
      Unless u = Unless(2, Self(1), Zilch(3));
      expect(u, Unless(2, Self(1), Zilch(3)));
      expect(u, isNot(Unless(4, Self(1), Zilch(3))));
      expect(u, isNot(Unless(2, Self(4), Zilch(3))));
      expect(u, isNot(Unless(2, Self(1), Zilch(4))));
      expect(u, isNot(Unless(2, Main(1), Zilch(3))));
      expect(u, isNot(Unless(2, Self(1), Main(3))));
      expect(u, isNot(Equal(2, Self(1), Zilch(3))));
      expect(u.length, 3);
      expect(u.hasPlaceDescendant, false);
      expect(u.toString(), "(S U Z)");
    });
    test("nested", () {
      BinaryExpression e = 
        Equal(4, Unless(2, Main(1), Self(3)), Equal(7, Not(5, Zilch(6)), Invoke(8, Main(9))))
      ;
      expect(e, 
        Equal(4, Unless(2, Main(1), Self(3)), Equal(7, Not(5, Zilch(6)), Invoke(8, Main(9))))
      );
      expect(e, isNot(
        Equal(4, Unless(2, Main(1), Self(3)), Equal(7, Not(5, Zilch(6)), Main(8)))
      ));
      expect(e, isNot(
        Equal(4, Unless(2, Main(1), Self(3)), Equal(7, Length(5, Zilch(6)), Invoke(8, Main(9))))
      ));
      expect(e, isNot(
        Equal(4, Unless(2, Main(1), Self(3)), Unless(7, Not(5, Zilch(6)), Invoke(8, Main(9))))
      ));
      expect(e, isNot(
        Unless(4, Unless(2, Main(1), Self(3)), Equal(7, Not(5, Zilch(6)), Invoke(8, Main(9))))
      ));
      expect(e, isNot(
        Equal(10, Unless(2, Main(1), Self(3)), Equal(7, Not(5, Zilch(6)), Invoke(8, Main(9))))
      ));
      expect(e, isNot(
        Equal(4, Unless(10, Main(1), Self(3)), Equal(7, Not(5, Zilch(6)), Invoke(8, Main(9))))
      ));
      expect(e, isNot(
        Equal(4, Unless(2, Main(10), Self(3)), Equal(7, Not(5, Zilch(6)), Invoke(8, Main(9))))
      ));
      expect(e, isNot(
        Equal(4, Unless(2, Main(1), Self(3)), Equal(10, Not(5, Zilch(6)), Invoke(8, Main(9))))
      ));
      expect(e, isNot(
        Equal(4, Unless(2, Main(1), Self(3)), Equal(7, Not(5, Zilch(6)), Invoke(10, Main(9))))
      ));
      expect(e, isNot(
        Equal(4, Unless(2, Main(1), Self(3)), Equal(7, Not(5, Zilch(6)), Invoke(8, Main(10))))
      ));
      expect(e.length, 9);
      expect(e.leftOperand.length, 3);
      expect(e.rightOperand, 5);
      expect(e.hasPlaceDescendant, false);
      expect(e.toString(), "((M U S) Q ((N Z) Q (V M)))");
    });
  });
  group("OptionallyBinaryExpression: ", () {
    test("Access (unary)", () {
      Access a = Access(1, Number(2, value: 0));
      expect(a, Access(1, Number(2, value: 0)));
      expect(a, isNot(Access(3, Number(2, value: 0))));
      expect(a, isNot(Access(1, Number(3, value: 0))));
      expect(a, isNot(Access(1, Number(2, value: 1))));
      expect(a, isNot(Borrow(1, Number(2, value: 0))));
      expect(a.length, 2);
      expect(a.hasPlaceDescendant, false);
      expect(a.toString(), "(A 0)");
    });
    test("Access (binary)", () {
      Access a = Access(1, Self(3), Zilch(1));
      expect(a, Access(1, Self(3), Zilch(1)));
      expect(a, isNot(Access(4, Self(3), Zilch(1))));
      expect(a, isNot(Access(1, Self(4), Zilch(1))));
      expect(a, isNot(Access(1, Self(3), Zilch(4))));
      expect(a, isNot(Access(1, Main(3), Zilch(1))));
      expect(a, isNot(Access(1, Self(3), Main(1))));
      expect(a, isNot(Borrow(1, Self(3), Zilch(1))));
      expect(a.length, 3);
      expect(a.hasPlaceDescendant, false);
      expect(a.toString(), "(Z A S)");
    });
    test("Borrow (unary)", () {
      Borrow b = Borrow(1, Main(2));
      expect(b, Borrow(1, Main(2)));
      expect(b, isNot(Borrow(3, Main(2))));
      expect(b, isNot(Borrow(1, Main(3))));
      expect(b, isNot(Borrow(1, Zilch(2))));
      expect(b, isNot(Access(1, Main(2))));
      expect(b.length, 2);
      expect(b.hasPlaceDescendant, false);
      expect(b.toString(), "(B 0)");
    });
    test("Borrow (binary)", () {
      Borrow b = Borrow(1, Zilch(3), Self(1));
      expect(b, Borrow(1, Zilch(3), Self(1)));
      expect(b, isNot(Borrow(4, Zilch(3), Self(1))));
      expect(b, isNot(Borrow(1, Zilch(4), Self(1))));
      expect(b, isNot(Borrow(1, Zilch(3), Self(4))));
      expect(b, isNot(Borrow(1, Main(3), Self(1))));
      expect(b, isNot(Borrow(1, Zilch(3), Main(1))));
      expect(b, isNot(Access(1, Zilch(3), Self(1))));
      expect(b.length, 3);
      expect(b.hasPlaceDescendant, false);
      expect(b.toString(), "(S B Z)");
    });
    test("nested", () {
      OptionallyBinaryExpression e = Access(3, Borrow(6, Zilch(7), Access(4, Self(5))), Borrow(1, Main(2)));
      expect(e, Access(1, Borrow(6, Zilch(7), Access(4, Self(5))), Borrow(1, Main(2))));
      expect(e, isNot(Access(8, Borrow(4, Zilch(7), Access(4, Self(5))), Borrow(1, Main(2)))));
      expect(e, isNot(Access(1, Borrow(8, Zilch(7), Access(4, Self(5))), Borrow(1, Main(2)))));
      expect(e, isNot(Access(1, Borrow(4, Zilch(8), Access(4, Self(5))), Borrow(1, Main(2)))));
      expect(e, isNot(Access(1, Borrow(4, Zilch(7), Access(8, Self(5))), Borrow(1, Main(2)))));
      expect(e, isNot(Access(1, Borrow(4, Zilch(7), Access(4, Self(8))), Borrow(1, Main(2)))));
      expect(e, isNot(Access(1, Borrow(4, Zilch(7), Access(4, Self(5))), Borrow(8, Main(2)))));
      expect(e, isNot(Access(1, Borrow(4, Zilch(7), Access(4, Self(5))), Borrow(1, Main(8)))));
      expect(e, isNot(Borrow(1, Borrow(4, Zilch(7), Access(4, Self(5))), Borrow(1, Main(2)))));
      expect(e, isNot(Access(1, Access(4, Zilch(7), Access(4, Self(5))), Borrow(1, Main(2)))));
      expect(e, isNot(Access(1, Borrow(4, Main(7), Access(4, Self(5))), Borrow(1, Main(2)))));
      expect(e, isNot(Access(1, Borrow(4, Zilch(7), Borrow(4, Self(5))), Borrow(1, Main(2)))));
      expect(e, isNot(Access(1, Borrow(4, Zilch(7), Access(4, Zilch(5))), Borrow(1, Main(2)))));
      expect(e, isNot(Access(1, Borrow(4, Zilch(7), Self(5)), Borrow(1, Main(2)))));
      expect(e, isNot(Access(1, Borrow(4, Zilch(7)), Borrow(1, Main(2)))));
      expect(e, isNot(Access(1, Borrow(4, Zilch(7), Access(4, Self(5))), Access(1, Main(2)))));
      expect(e, isNot(Access(1, Borrow(4, Zilch(7), Access(4, Self(5))), Borrow(1, Self(2)))));
      expect(e, isNot(Access(1, Borrow(4, Zilch(7), Access(4, Self(5))))));
      expect(e.length, 7);
      expect(e.leftOperand!.length, 2);
      expect(e.rightOperand.length, 4);
      expect((e.rightOperand as OptionallyBinaryExpression).leftOperand!.length, 2);
      expect(e.hasPlaceDescendant, false);
      expect(e.toString(), "((B M) A ((A S) B Z))");
    });
    test("hasPlaceDescendant", () {
      OptionallyBinaryExpression right = Access(1, Func(1, [Place(2)]));
      OptionallyBinaryExpression left = Borrow(1, Zilch(1), Func(3, [Place(4)]));
      expect(right.hasPlaceDescendant, true);
      expect(left.hasPlaceDescendant, true);
    });
  });
  group("linK", () {
    test("too small", () {
      expect(Link(1, []), throwsA(isA<AssertionError>()));
      expect(Link(1, [Zilch(0)]), throwsA(isA<AssertionError>()));
    });
    test("minimal", () {
      Link k = Link(1, [Main(1), Self(3)]);
      expect(k, Link(1, [Main(1), Self(3)]));
      expect(k, isNot(Link(4, [Main(1), Self(3)])));
      expect(k, isNot(Link(1, [Main(4), Self(3)])));
      expect(k, isNot(Link(1, [Main(1), Self(4)])));
      expect(k, isNot(Link(1, [Self(3), Main(1)])));
      expect(k, isNot(Link(1, [Zilch(1), Self(3)])));
      expect(k, isNot(Link(1, [Main(1), Zilch(3)])));
      expect(k.length, 3);
      expect(k.hasPlaceDescendant, false);
      expect(k.toString(), "(M K S)");
    });
    test("complex", () {
      Link k = Link(1, [
        Access(1, Examine(3, Main(4)), Self(1)),
        Wait(6, Zilch(7)),
        Main(9),
        Link(10, [Self(10), Zilch(12)]),
        Func(14, [Place(15)])
      ]);
      expect(k, Link(1, [
        Access(1, Examine(3, Main(4)), Self(1)),
        Wait(6, Zilch(7)),
        Main(9),
        Link(10, [Self(10), Zilch(12)]),
        Func(14, [Place(15)])
      ]));
      expect(k, isNot(Link(16, [
        Access(1, Examine(3, Main(4)), Self(1)),
        Wait(6, Zilch(7)),
        Main(9),
        Link(10, [Self(10), Zilch(12)]),
        Func(14, [Place(15)])
      ])));
      expect(k, Link(1, [
        Access(16, Examine(3, Main(4)), Self(1)),
        Wait(6, Zilch(7)),
        Main(9),
        Link(10, [Self(10), Zilch(12)]),
        Func(14, [Place(15)])
      ]));
      expect(k, Link(1, [
        Access(1, Examine(3, Main(4)), Self(1)),
        Wait(16, Zilch(7)),
        Main(9),
        Link(10, [Self(10), Zilch(12)]),
        Func(14, [Place(15)])
      ]));
      expect(k, Link(1, [
        Access(1, Examine(3, Main(4)), Self(1)),
        Wait(6, Zilch(7)),
        Main(16),
        Link(10, [Self(10), Zilch(12)]),
        Func(14, [Place(15)])
      ]));
      expect(k, Link(1, [
        Access(1, Examine(3, Main(4)), Self(1)),
        Wait(6, Zilch(7)),
        Main(9),
        Link(16, [Self(10), Zilch(12)]),
        Func(14, [Place(15)])
      ]));
      expect(k, Link(1, [
        Access(1, Examine(3, Main(4)), Self(1)),
        Wait(6, Zilch(7)),
        Main(9),
        Link(10, [Self(10), Zilch(12)]),
        Func(16, [Place(15)])
      ]));
      expect(k, Link(1, [
        Borrow(1, Examine(3, Main(4)), Self(1)),
        Wait(6, Zilch(7)),
        Main(9),
        Link(10, [Self(10), Zilch(12)]),
        Func(14, [Place(15)])
      ]));
      expect(k, Link(1, [
        Access(1, Examine(3, Main(4)), Self(1)),
        Copy(6, Zilch(7)),
        Main(9),
        Link(10, [Self(10), Zilch(12)]),
        Func(14, [Place(15)])
      ]));
      expect(k, Link(1, [
        Access(1, Examine(3, Main(4)), Self(1)),
        Wait(6, Zilch(7)),
        Self(9),
        Link(10, [Self(10), Zilch(12)]),
        Func(14, [Place(15)])
      ]));
      expect(k, Link(1, [
        Access(1, Examine(3, Main(4)), Self(1)),
        Wait(6, Zilch(7)),
        Main(9),
        Func(14, [Place(15)])
      ]));
      expect(k, Link(1, [
        Access(1, Examine(3, Main(4)), Self(1)),
        Wait(6, Zilch(7)),
        Main(9),
        Link(10, [Self(10), Zilch(12)]),
        Func(14, [Place(15)]),
        Zilch(17)
      ]));
      expect(k, isNot(Zilch(1)));
      expect(k.length, 16);
      expect(k.hasPlaceDescendant, true);
      expect(k.toString(), "("
        "(S A (X M)) K "
        "(W Z) K "
        "M K "
        "(S K Z) K "
        "F {P} E"
      ")");
    });
  });
  group("Function", () {
    test ("empty block", () {
      Func f = Func(1, []);
      expect(f, Func(1, []));
      expect(f, isNot(Func(2, [])));
      expect(f, isNot(Func(1, [Jump(2, Zilch(3))])));
      expect(f.length, 2);
      expect(f.hasPlaceDescendant, false);
      expect(f.toString(), "F {} E");
    });
    test("multiline", () {
      Func f = Func(1, [
        Place(2),
        If(3, Read(4, Zilch(5)), [Yield(7, Self(8))]),
        Jump(10, Number(11, value: -1)),
        Throw(12, Func(13, [])),
      ]);
      expect(f, Func(1, [
        Place(2),
        If(3, Read(4, Zilch(5)), [Yield(7, Self(8))]),
        Jump(10, Number(11, value: -1)),
        Throw(12, Func(13, [])),
      ]));
      expect(f, isNot(Func(14, [
        Place(2),
        If(3, Read(4, Zilch(5)), [Yield(7, Self(8))]),
        Jump(10, Number(11, value: -1)),
        Throw(12, Func(13, [])),
      ])));
      expect(f, isNot(Func(1, [
        Place(14),
        If(3, Read(4, Zilch(5)), [Yield(7, Self(8))]),
        Jump(10, Number(11, value: -1)),
        Throw(12, Func(13, [])),
      ])));
      expect(f, isNot(Func(1, [
        Place(2),
        If(14, Read(4, Zilch(5)), [Yield(7, Self(8))]),
        Jump(10, Number(11, value: -1)),
        Throw(12, Func(13, [])),
      ])));
      expect(f, isNot(Func(1, [
        Place(2),
        If(3, Read(4, Zilch(5)), [Yield(7, Self(8))]),
        Jump(14, Number(11, value: -1)),
        Throw(12, Func(13, [])),
      ])));
      expect(f, isNot(Func(1, [
        Place(2),
        If(3, Read(4, Zilch(5)), [Yield(7, Self(8))]),
        Jump(10, Number(11, value: -1)),
        Throw(14, Func(13, [])),
      ])));
      expect(f, isNot(Func(1, [
        Place(2),
        If(3, Read(4, Zilch(5)), [Yield(7, Self(8))]),
        Jump(10, Number(11, value: -1)),
        Throw(12, Func(14, [])),
      ])));
      expect(f, isNot(Func(1, [
        If(3, Read(4, Zilch(5)), [Yield(7, Self(8))]),
        Jump(10, Number(11, value: -1)),
        Throw(12, Func(13, [])),
      ])));
      expect(f, isNot(Func(1, [
        Throw(12, Func(13, [])),
        Place(2),
        If(3, Read(4, Zilch(5)), [Yield(7, Self(8))]),
        Jump(10, Number(11, value: -1)),
      ])));
      expect(f, isNot(Func(1, [
        Place(2),
        Defer(3, Read(4, Zilch(5)), [Yield(7, Self(8))]),
        Jump(10, Number(11, value: -1)),
        Throw(12, Func(13, [])),
      ])));
      expect(f, isNot(Func(1, [
        Place(2),
        If(3, Read(4, Zilch(5)), [Yield(7, Self(8))]),
        Jump(10, Number(11, value: -1)),
        Throw(12, Func(13, [])),
        Place(15)
      ])));
      expect(f.length, 15);
      expect(f.hasPlaceDescendant, true);
      expect(f.toString(), "F {"
        "P;"
        "I (R Z) T {Y S;} E"
        "J -1;"
        "O F {} E;"
      "}");
    });
  });
  group("NullaryStatement", () {
    test("Place", () {
      Place p = Place(1);
      expect(p, Place(1));
      expect(p, isNot(Place(2)));
      expect(p, isNot(Zilch(1)));
      expect(p, isNot(Jump(1, Zilch(2))));
      expect(p, isNot(If(1, Zilch(2), [])));
      expect(p.length, 1);
      expect(p.hasPlaceDescendant, true);
      expect(p.toString(), 'P;');
    });
  });
  group("UnaryStatement", () {
    test("Jump", () {
      Jump j = Jump(1, Main(2));
      expect(j, Jump(1, Main(2)));
      expect(j, isNot(Jump(3, Main(2))));
      expect(j, isNot(Jump(1, Main(3))));
      expect(j, isNot(Throw(1, Main(2))));
      expect(j, isNot(Jump(1, Self(2))));
      expect(j.length, 2);
      expect(j.hasPlaceDescendant, false);
      expect(j.toString(), "J M;");
    });
    test("thrOw", () {
      Throw o = Throw(1, Examine(2, Self(3)));
      expect(o, Throw(1, Examine(2, Self(3))));
      expect(o, isNot(Throw(4, Examine(2, Self(3)))));
      expect(o, isNot(Throw(1, Examine(4, Self(3)))));
      expect(o, isNot(Yield(1, Examine(2, Self(3)))));
      expect(o, isNot(Throw(1, Examine(2, Zilch(3)))));
      expect(o.length, 3);
      expect(o.hasPlaceDescendant, false);
      expect(o.toString(), "O (X S);");
    });
    test("Yield", () {
      Yield y = Yield(1, Func(2, [Place(3)]));
      expect(y, Yield(1, Func(2, [Place(3)])));
      expect(y, isNot(Yield(4, Func(2, [Place(3)]))));
      expect(y, isNot(Yield(1, Func(4, [Place(3)]))));
      expect(y, isNot(Jump(1, Func(2, [Place(3)]))));
      expect(y, isNot(Yield(1, Func(2, []))));
      expect(y.length, 4);
      expect(y.hasPlaceDescendant, true);
      expect(y.toString(), "Y F {P} E;");
    });
  });
  group("BinaryStatement", () {
    test("Gets", () {
      // TODO
    });
  });
  group("ConditionalStatement", () {
    test("If", () {
      If i = If(Read(), [Write(Zilch()), Jump(Number(0))]);
      expect(i, If(Read(), [Write(Zilch()), Jump(Number(0))]));
      expect(i, isNot(If(Read(), [Write(Zilch()), Jump(Number(0))], [])));
      expect(i, isNot(During(Read(), [Write(Zilch()), Jump(Number(0))])));
      expect(i.toString(), "I R T W Z; J 0; E");
    });
    test("If/Not Then)", () {
      If i = If(Number(1), [Throw(Length()), Write(Self())], [Yield(Self())]);
      expect(i, If(Number(1), [Throw(Length()), Write(Self())], [Yield(Self())]));
      expect(i, isNot(If(Number(0), [Throw(Length()), Write(Self())], [Yield(Self())])));
      expect(i, isNot(If(Number(1), [Throw(Length()), Write(Self())], [Yield(Access(Self()))])));
      expect(i.toString(), "I 1 T O L; W S; E NT Y S; E");
    });
    test("Defer", () {
      // TODO
    });
  });
  group("ReactiveStatement", () {
    test("catcH", () {
      // TODO
    });
  });
  group("Program", () {
    test ("empty block", () {
      Program program = Program([]);
      expect(program, Program([]));
      expect(program, isNot(Program([Jump(Length())])));
      expect(program, isNot(Func([])));
      expect(program.toString(), "");
    });
    test('"integration test"', () {
      // TODO
    });
  });
}
