class A inherits IO {
    blah : Int <- { print(1); 1; };
  identify() : Object { out_string("A\n") };
  duplicate() : A { new SELF_TYPE };
  print(value : Int) : SELF_TYPE {{
        out_int( value );
        out_string( "\n" );
        self;
    }};
};


class B inherits A {
blah2: Int <- { print(2); 2; };
  identify() : Object { out_string( "B\n" ) };
  report(value : Int) : SELF_TYPE { {
    out_string("old: ");
    out_int(blah2);
    out_string(".  new: ");
    blah2 <- value;
    self@A.print(blah2);
  }};
};


class Main  {
  main() : Object { (new B).print(69).duplicate().print(420) };
};