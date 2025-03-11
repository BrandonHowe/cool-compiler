class Main inherits IO {
  a: Int <- 0;
  f(i: Int): Object { i <- 1 };
  main(): Object {{
    f(a);
    out_int(a);
  }};
};