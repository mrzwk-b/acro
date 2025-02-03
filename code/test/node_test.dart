import 'package:test/test.dart';
import '../src/node.dart';

// test toString and == implementation for all instantiable Node subclasses

void main() {
  group("NullaryExpression: ", () {
    test("Main", () {
      Main m = Main(0);
      expect(m, Main(0));
      expect(m, isNot(Main(1)));
      expect(m, isNot(Self(0)));
      expect(m.toString(), 'M');
    });
    test("Self", () {
      Self s = Self(0);
      expect(s, Self(0));
      expect(s, isNot(Self(1)));
      expect(s, isNot(Zilch(0)));
      expect(s.toString(), 'S');
    });
    test("Zilch", () {
      Zilch z = Zilch(0);
      expect(z, Zilch(0));
      expect(z, isNot(Zilch(1)));
      expect(z, isNot(Number(0, value: 0)));
      expect(z.toString(), 'Z');
    });
    test("Number", () {
      Number one = Number(0, value: 1);
      expect(one, Number(0, value: 1));
      expect(one, isNot(Number(0, value: 0)));
      expect(one, isNot(Number(1, value: 1)));
      expect(one, isNot(Self(0)));
      expect(one.toString(), '1');
    });
  });
  group("UnaryExpression: ", () {
    test("Copy", () {
      Copy c = Copy(0, Main(1));
      expect(c, Copy(0, Main(1)));
      expect(c, isNot(Copy(2, Main(1))));
      expect(c, isNot(Copy(0, Main(2))));
      expect(c, isNot(Copy(0, Self(1))));
      expect(c, isNot(Length(0, Main(0))));
      expect(c.toString(), "(C M)");
    });
    test("Length", () {
      Length l = Length(0, Self(1));
      expect(l, Length(0, Self(1)));
      expect(l, isNot(Length(2, Self(1))));
      expect(l, isNot(Length(0, Self(2))));
      expect(l, isNot(Length(0, Zilch(1))));
      expect(l, isNot(Not(0, Self(1))));
      expect(l.toString(), "(L S)");
    });
    test("Not", () {
      Not n = Not(0, Zilch(1));
      expect(n, Not(0, Zilch(1)));
      expect(n, isNot(Not(0, Zilch(2))));
      expect(n, isNot(Not(2, Zilch(1))));
      expect(n, isNot(Not(0, Main(1))));
      expect(n, isNot(Invoke(0, Zilch(1))));
      expect(n.toString(), "(N Z)");
    });
    test("inVoke", () {
      Invoke v = Invoke(0, Main(1));
      expect(v, Invoke(0, Main(1)));
      expect(v, isNot(Invoke(0, Main(0))));
      expect(v, isNot(Invoke(1, Main(1))));
      expect(v, isNot(Invoke(0, Self(1))));
      expect(v, isNot(Copy(0, Main(1))));
      expect(v.toString(), "(V M)");
    });
    test("nested", () {
      Expression e = Length(0, Copy(1, Not(2, Invoke(3, Zilch(4)))));
      expect(e, Length(0, Copy(1, Not(2, Invoke(3, Zilch(4))))));
      expect(e, isNot(Length(5, Copy(1, Not(2, Invoke(3, Zilch(4)))))));
      expect(e, isNot(Length(0, Copy(5, Not(2, Invoke(3, Zilch(4)))))));
      expect(e, isNot(Length(0, Copy(1, Not(5, Invoke(3, Zilch(4)))))));
      expect(e, isNot(Length(0, Copy(1, Not(2, Invoke(5, Zilch(4)))))));
      expect(e, isNot(Length(0, Copy(1, Not(2, Invoke(3, Zilch(5)))))));
      expect(e, isNot(Not(0, Copy(1, Not(2, Invoke(3, Zilch(4)))))));
      expect(e, isNot(Length(0, Invoke(1, Not(2, Invoke(3, Zilch(4)))))));
      expect(e, isNot(Length(0, Copy(1, Length(2, Invoke(3, Zilch(4)))))));
      expect(e, isNot(Length(0, Copy(1, Not(2, Copy(3, Zilch(4)))))));
      expect(e, isNot(Length(0, Copy(1, Not(2, Invoke(3, Self(4)))))));
      expect(e.toString(), "(L (C (N (V Z))))");
    });
  });
  group("BinaryExpression: ", () {
    test("eQual", () {
      Equal q = Equal(1, Zilch(0), Self(2));
      expect(q, Equal(1, Zilch(0), Self(2)));
      expect(q, isNot(Equal(3, Zilch(0), Self(2))));
      expect(q, isNot(Equal(1, Zilch(3), Self(2))));
      expect(q, isNot(Equal(1, Zilch(0), Self(3))));
      expect(q, isNot(Equal(1, Main(0), Self(2))));
      expect(q, isNot(Equal(1, Zilch(0), Main(2))));
      expect(q, isNot(Unless(1, Zilch(0), Self(2))));
      expect(q.toString(), "(Z Q S)");
    });
    test("Unless", () {
      Unless u = Unless(1, Self(0), Zilch(2));
      expect(u, Unless(1, Self(0), Zilch(2)));
      expect(u, isNot(Unless(3, Self(0), Zilch(2))));
      expect(u, isNot(Unless(1, Self(3), Zilch(2))));
      expect(u, isNot(Unless(1, Self(0), Zilch(3))));
      expect(u, isNot(Unless(1, Main(0), Zilch(2))));
      expect(u, isNot(Unless(1, Self(0), Main(2))));
      expect(u, isNot(Equal(1, Self(0), Zilch(2))));
      expect(u.toString(), "(S U Z)");
    });
    test("nested", () {
      Expression e = 
        Equal(3, Unless(1, Read(0), Length(2)), Equal(6, Not(4, Self(5)), Invoke(7, Main(8))))
      ;
      expect(e, 
        Equal(3, Unless(1, Read(0), Length(2)), Equal(6, Not(4, Self(5)), Invoke(7, Main(8))))
      );
      expect(e, isNot(
        Unless(3, Unless(1, Read(0), Length(2)), Equal(6, Not(4, Self(5)), Invoke(7, Main(8))))
      ));
      expect(e, isNot(
        Equal(3, Unless(1, Read(0), Length(2)), Equal(6, Not(4, Self(5)), Main(7)))
      ));
      expect(e, isNot(
        Equal(3, Unless(1, Read(0), Length(2)), Equal(6, Not(4, Self(5)), Main(7)))
      ));
      expect(e, isNot(
        Equal(9, Unless(1, Read(0), Length(2)), Equal(6, Not(4, Self(5)), Invoke(7, Main(8))))
      ));
      expect(e, isNot(
        Equal(3, Unless(9, Read(0), Length(2)), Equal(6, Not(4, Self(5)), Invoke(7, Main(8))))
      ));
      expect(e, isNot(
        Equal(3, Unless(1, Read(9), Length(2)), Equal(6, Not(4, Self(5)), Invoke(7, Main(8))))
      ));
      expect(e, isNot(
        Equal(3, Unless(1, Read(0), Length(2)), Equal(6, Not(4, Self(5)), Invoke(7, Main(9))))
      ));
      expect(e.toString(), "((R U L) Q ((N S) Q (V M)))");
    });
  });
  group("OptionallyBinaryExpression: ", () {
    test("Access (unary)", () {
      Access unary = Access(0, Number(1, value: 0));
      expect(unary, Access(0, Number(1, value: 0)));
      expect(unary, isNot(Access(2, Number(1, value: 0))));
      expect(unary, isNot(Access(0, Number(2, value: 0))));
      expect(unary, isNot(Access(0, Number(1, value: 1))));
      expect(unary, isNot(Borrow(0, Number(1, value: 0))));
      expect(unary.toString(), "(A 0)");
    });
    test("Access (binary)", () {
      Access binary = Access(1, Read(0), Length(2));
      expect(binary, Access(1, Read(0), Length(2)));
      expect(binary, isNot(Access(3, Read(0), Length(2))));
      expect(binary, isNot(Access(1, Read(3), Length(2))));
      expect(binary, isNot(Access(1, Read(0), Length(3))));
      expect(binary, isNot(Access(1, Self(0), Length(2))));
      expect(binary, isNot(Access(1, Read(0), Self(2))));
      expect(binary, isNot(Borrow(1, Read(0), Length(2))));
      expect(binary.toString(), "(R A L)");
    });
    test("Borrow (unary)", () {
      Borrow unary = Borrow(0, Length(1));
      expect(unary, Borrow(0, Length(1)));
      expect(unary, isNot(Borrow(2, Length(1))));
      expect(unary, isNot(Borrow(0, Length(2))));
      expect(unary, isNot(Borrow(0, Number(1, value: 0))));
      expect(unary, isNot(Access(0, Length(1))));
      expect(unary.toString(), "(B 0)");
    });
    test("Borrow (binary)", () {
      Borrow binary = Borrow(1, Zilch(0), Self(2));
      expect(binary, Borrow(1, Zilch(0), Self(2)));
      expect(binary, isNot(Borrow(1, Main(0), Self(2))));
      expect(binary, isNot(Borrow(1, Zilch(0), Read(2))))
      expect(binary, isNot(Access(1, Zilch(0), Self(2))));
      expect(binary.toString(), "(Z B S)");
    });
    test("nested", () {
      Expression e = Access(Borrow(Number(1), Access(Length())), Borrow(Read()));
      expect(e, Access(Borrow(Number(1), Access(Length())), Borrow(Read())));
      expect(e, isNot(Access(Borrow(Number(2), Access(Length())), Borrow(Read()))));
      expect(e, isNot(Access(Borrow(Number(2), Access(Length())), Access(Read()))));
      expect(e, isNot(Borrow(Borrow(Number(2), Access(Length())), Borrow(Read()))));
      expect(e.toString(), "((1 B (A L)) A (B R))");
    });
  });
  group("linK", () {
    test("empty", () {
      Link k = Link([]);
      expect(k, Link([]));
      expect(k, isNot(Link([Zilch()])));
      expect(k, isNot(Zilch()));
      expect(k.toString(), "()");
    });
    test("singleton", () {
      Link k = Link([Zilch()]);
      expect(k, Link([Zilch()]));
      expect(k, isNot(Link([Zilch(), Number(0)])));
      expect(k, isNot(Invoke(Zilch())));
      expect(k.toString(), "(Z)");
    });
    test("full", () {
      Link k = Link([Zilch(), Number(0), Self(), Length(), Read()]);
      expect(k, Link([Zilch(), Number(0), Self(), Length(), Read()]));
      expect(k, isNot(Link([Number(0), Zilch(), Self(), Length(), Read()])));
      expect(k.toString(), "(Z K 0 K S K L K R)");
    });
  });
  group("Unary Statement", () {
    test("Jump", () {
      Jump j = Jump(Number(0));
      expect(j, Jump(Number(0)));
      expect(j, isNot(Throw(Number(0))));
      expect(j, isNot(Jump(Length())));
      expect(j.toString(), "J 0;");
    });
    test("thrOw", () {
      Throw t = Throw(Length());
      
      expect(t, Throw(Length()));
      expect(t, isNot(Write((Length()))));
      expect(t, isNot(Throw((Read()))));
      expect(t.toString(), "O L;");
    });
    test("Write", () {
      Write t = Write(Read());
      
      expect(t, Write(Read()));
      expect(t, isNot(Yield((Read()))));
      expect(t, isNot(Write((Self()))));
      expect(t.toString(), "W R;");
    });
    test("Yield", () {
      Yield t = Yield(Self());
      
      expect(t, Yield(Self()));
      expect(t, isNot(Jump((Self()))));
      expect(t, isNot(Yield((Number(0)))));
      expect(t.toString(), "Y S;");
    });
  });
  group("Gets", () {
    test("Gets", () {
      Gets g = Gets(Access(Number(0)), Read());
      expect(g, Gets(Access(Number(0)), Read()));
      expect(g, isNot(Gets(Access(Number(0)), Length())));
      expect(g, isNot(Access(Access(Number(0)), Read())));
      expect(g.toString(), "(A 0) G R;");
    }); 
  });
  group("During", () {
    test("empty block", () {
      During d = During(Unless(Read(), Length()), []);
      expect(d, During(Unless(Read(), Length()), []));
      expect(d, isNot(During(Unless(Read(), Self()), [])));
      expect(d, isNot(If(Unless(Read(), Length()), [])));
      expect(d.toString(), "D (R U L) T  E");
    });
    test("multiline and nested", () {
      During d = During(Zilch(), [
        Gets(Access(Number(0)), Borrow(Zilch())),
        Write(Read()),
        During(Length(), [Throw(Self())]),
      ]);
      expect(d, During(Zilch(), [
        Gets(Access(Number(0)), Borrow(Zilch())),
        Write(Read()),
        During(Length(), [Throw(Self())]),
      ]));
      expect(d, isNot(During(Zilch(), [
        Gets(Access(Number(0)), Borrow(Zilch())),
        Write(Read()),
        During(Length(), [Yield(Self())]),
      ])));
      expect(d, isNot(If(Zilch(), [
        Gets(Access(Number(0)), Borrow(Zilch())),
        Write(Read()),
        During(Length(), [Throw(Self())]),
      ])));
      expect(d.toString(), "D Z T (A 0) G (B Z); W R; D L T O S; E E");
    });
  });
  group("If", () {
    test("If", () {
      If i = If(Read(), [Write(Zilch()), Jump(Number(0))]);
      expect(i, If(Read(), [Write(Zilch()), Jump(Number(0))]));
      expect(i, isNot(If(Read(), [Write(Zilch()), Jump(Number(0))], [])));
      expect(i, isNot(During(Read(), [Write(Zilch()), Jump(Number(0))])));
      expect(i.toString(), "I R T W Z; J 0; E");
    });
    test("If/Else", () {
      If i = If(Number(1), [Throw(Length()), Write(Self())], [Yield(Self())]);
      expect(i, If(Number(1), [Throw(Length()), Write(Self())], [Yield(Self())]));
      expect(i, isNot(If(Number(0), [Throw(Length()), Write(Self())], [Yield(Self())])));
      expect(i, isNot(If(Number(1), [Throw(Length()), Write(Self())], [Yield(Access(Self()))])));
      expect(i.toString(), "I 1 T O L; W S; E NT Y S; E");
    });
  });
  // TODO test aWait
  group("eXpect", () { // not to be confused with expect(), eXpect is our keyword for try blocks
    test("empty blocks", () {
      Expect x = Expect([], []);
      expect(x, Expect([], []));
      expect(x, isNot(Expect([], [Jump(Zilch())])));
      expect(x, isNot(During(Zilch(), [])));
      expect(x.toString(), "X  H  E");
    });
    test("full blocks", () {
      Expect x = Expect([Throw(Read())], [Write(Access(Self(), Number(0))), Yield(Length())]);
      expect(x, Expect([Throw(Read())], [Write(Access(Self(), Number(0))), Yield(Length())]));
      expect(x, isNot(Expect([Throw(Access(Number(0)))], [Write(Access(Self(), Number(0))), Yield(Length())])));
      expect(x, isNot(If(Zilch(), [Throw(Read())], [Write(Access(Self(), Number(0))), Yield(Length())])));
      expect(x.toString(), "X O R; H W (S A 0); Y L; E");
    });
  });
  group("Func", () {
    test ("empty block", () {
      Func f = Func([]);
      expect(f, Func([]));
      expect(f, isNot(Func([Jump(Zilch())])));
      expect(f, isNot(Class([])));
      expect(f.toString(), "F  E");
    });
    test("full block", () {
      Func f = Func([
        Write(Access(Length())),
        Gets(Access(Length()), Read()),
        During(Zilch(), [Jump(Number(10))]),
        Yield(Self())
      ]);

      expect(f, Func([
        Write(Access(Length())),
        Gets(Access(Length()), Read()),
        During(Zilch(), [Jump(Number(10))]),
        Yield(Self())
      ]));
      expect(f, isNot(Func([
        Write(Access(Length())),
        Gets(Access(Length()), Read()),
        During(Zilch(), [Jump(Number(5))]),
        Yield(Self())
      ])));
      expect(f, isNot(Func([
        Write(Invoke(Length())),
        Gets(Access(Length()), Read()),
        During(Zilch(), [Jump(Number(10))]),
        Yield(Self())
      ])));
      expect(f.toString(), 
        "F W (A L); (A L) G R; D Z T J 10; E Y S; E"
      );
    });
  });
  group("Class", () {
    test ("empty block", () {
      Class c = Class([]);
      expect(c, Class([]));
      expect(c, isNot(Class([Gets(Access(Number(0)), Zilch())])));
      expect(c, isNot(Program([])));
      expect(c.toString(), "C  E");
    });
    test("full block", () {
      Class c = Class([
        Gets(Access(Self(), Number(0)), Func([Yield(Access(Self(), Number(1)))])),
        Write(Invoke(Read())),
        Jump(Zilch()),
      ]);
      expect(c, Class([
        Gets(Access(Self(), Number(0)), Func([Yield(Access(Self(), Number(1)))])),
        Write(Invoke(Read())),
        Jump(Zilch()),
      ]));
      expect(c, isNot(Class([
        Gets(Access(Self(), Number(0)), Func([Yield(Borrow(Self(), Number(1)))])),
        Write(Invoke(Read())),
        Jump(Zilch()),
      ])));
      expect(c, isNot(Func([
        Gets(Access(Self(), Number(0)), Func([Yield(Access(Self(), Number(1)))])),
        Write(Invoke(Read())),
        Jump(Zilch()),
      ])));
      expect(c.toString(), "C (S A 0) G F Y (S A 1); E; W (V R); J Z; E");
    });
    test("with borrow", () {
      Class c = Class([Gets(Access(Self(), Main()), Func([]))], Borrow(Zilch()));
      expect(c, Class([Gets(Access(Self(), Main()), Func([]))], Borrow(Zilch())));
      expect(c, isNot(Class([Gets(Access(Self(), Number(0)), Func([]))], Borrow(Zilch()))));
      expect(c, isNot(During(Borrow(Zilch()), [Gets(Access(Self(), Main()), Func([]))])));
      expect(c.toString(), "C (B Z) T (S A M) G F  E; E");
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
      Program program = Program([
        Gets(Access(Number(0)), Class([
          Gets(Access(Self(), Number(0)), Func([
            Expect(
              [
                If(Unless(Read(), Self()), 
                  [Write(Access(Length()))],
                  [Throw(Invoke(Access(Number(0))))]
                )
              ], 
              [Write(Number(1))]
            )
          ]))
        ], Borrow(Read(), Zilch()))),
        During(Zilch(), [If(Not(Read()), [Jump(Read())]), Yield(Zilch())])
      ]);

      expect(program, Program([
        Gets(Access(Number(0)), Class([
          Gets(Access(Self(), Number(0)), Func([
            Expect(
              [
                If(Unless(Read(), Self()), 
                  [Write(Access(Length()))],
                  [Throw(Invoke(Access(Number(0))))]
                )
              ], 
              [Write(Number(1))]
            )
          ]))
        ], Borrow(Read(), Zilch()))),
        During(Zilch(), [If(Not(Read()), [Jump(Read())]), Yield(Zilch())])
      ]));
      expect(program, isNot(Program([
        Gets(Access(Number(0)), Class([
          Gets(Access(Self(), Number(0)), Func([
            Expect(
              [
                If(Unless(Read(), Length()), 
                  [Write(Access(Length()))],
                  [Throw(Invoke(Access(Number(0))))]
                )
              ], 
              [Write(Number(1))]
            )
          ]))
        ], Borrow(Read(), Zilch()))),
        During(Zilch(), [If(Not(Read()), [Jump(Read())]), Yield(Zilch())])
      ])));
      expect(program, isNot(Class([
        Gets(Access(Number(0)), Class([
          Gets(Access(Self(), Number(0)), Func([
            Expect(
              [
                If(Unless(Read(), Self()), 
                  [Write(Access(Length()))],
                  [Throw(Invoke(Access(Number(0))))]
                )
              ], 
              [Write(Number(1))]
            )
          ]))
        ], Borrow(Read(), Zilch()))),
        During(Zilch(), [If(Not(Read()), [Jump(Read())]), Yield(Zilch())])
      ])));
      expect(program.toString(), 
        "(A 0) G C (R B Z) T "
          "(S A 0) G F X I (R U S) T W (A L); E NT O (V (A 0)); E H W 1; E E; "
        "E; "
        "D Z T I (N R) T J R; E Y Z; E"
      );
    });
  });
}
