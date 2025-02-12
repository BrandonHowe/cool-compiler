class A {
    method() : Int {
        5
    } ;
} ;

class Main inherits IO {
    a : A;
  main() : Object {
    {
        a.method();
        a.method2(); 
        out_string("Hello, world.\n") ;
    }
  } ;
} ; 
