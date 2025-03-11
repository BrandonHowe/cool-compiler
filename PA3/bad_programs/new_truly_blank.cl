class A inherits IO {
  x : Int <- x + 1;
  print(): Object {{
    out_string("x is ");
    out_int(x);
    out_string("\n");
  }};
  new_st(): A { new SELF_TYPE };
  inc(): Object { x <- x + 1 };
};

class Main {
  main():Object {
    let a1 : A <- new A, a2 : A
    in {
      a1.print();
      a1.inc();
      a1.inc();
      a1.inc();
      a1.print();
      a2 <- a1.new_st();
      a2.print();
      a1.print();
    }
  };
};