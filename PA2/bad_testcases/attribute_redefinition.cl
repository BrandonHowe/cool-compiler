class A {
    feature : Int <- 5;
} ;

class B inherits A {
    feature : Int <- 6;
} ;

class Main inherits IO {
  main() : Object { 
    out_string("Hello, world.\n") 
  } ;
} ; 
