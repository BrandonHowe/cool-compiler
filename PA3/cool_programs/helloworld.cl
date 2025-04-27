class A {
    foo() : Object { abort() };
};

class B inherits A {
    foo() : Object { let x : Int <- 123 in abort() };
};

class Main {
  x : Int;
  main() : Object {
    (new A).foo()
  };
};
