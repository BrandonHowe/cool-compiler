class Main inherits IO {
    a(val : Int) : String { "test" };
    b(val : Bool) : String { "blah" };
  main() : Object { 
    out_string(b(a(5)))
  } ;
} ; 
