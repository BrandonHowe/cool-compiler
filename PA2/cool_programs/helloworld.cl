(*class A {
    attr : Int <- 8;
    no_args() : Int { 5 };
    one_arg(arg: Int) : String { "test" };
};

class B inherits A {
    no_args() : Int { 5 };
};*)

class Main inherits IO {
    a : Int <- 5;
  main() : Object {
    let str : String <- "Hello, world.\n" in
    out_string(str)
  } ;
} ; 
