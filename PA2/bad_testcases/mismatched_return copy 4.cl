class Main inherits IO {
    hhh : Int <- 5;
    method4() : Int { { hhh <- 6; } };
  main() : Object { 
    {
        method4();
        out_string("Hello, world.\n") ;
    }
  } ;
} ; 
