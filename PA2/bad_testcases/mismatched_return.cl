class Main inherits IO {
    method() : String { 5 };
    method2() : Int { "asdf" };
    method3() : Bool { 123 };
    hhh : Int <- 5;
    method4() : Int { { hhh <- 6; } };
  main() : Object { 
    {
        method();
        out_string("Hello, world.\n") ;
    }
  } ;
} ; 
