class A {

} ; 

class B inherits A {
    
} ;

class Main inherits IO {
    attr : B;
  main() : Object { 
    {
        attr <- (new A);
        out_string("Hello, world.\n") ;
    }
  } ;
} ; 
