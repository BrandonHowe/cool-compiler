class A {
    feature : Int <- true;

    method() : Int {
        {
            feature <- "String";
            5;
        }
    };
} ;

class Main inherits IO {
  main() : Object { 
    out_string("Hello, world.\n") 
  } ;
} ; 
