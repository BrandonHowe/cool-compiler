class A inherits IO {
  identify() : Object { out_string("A\n") };
  duplicate() : A { copy() };
};


class B inherits A {
  identify() : Object { out_string( "B\n" ) };
};


class Main  {
  main() : Object { (new B).duplicate().identify() };
};