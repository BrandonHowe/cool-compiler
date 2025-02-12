class A {

} ; 

class B {
    
} ;

class Main inherits IO {
    attr : A;
    func(val : B) : A { attr };
  main() : Object { 
    {
        attr <- (new A);
        let blah : A <- func(attr) in
        out_string("Hello, world.\n") ;
    }
  } ;
} ; 
