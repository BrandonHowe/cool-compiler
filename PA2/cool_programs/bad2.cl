class A {

} ; 

class B inherits A {
    
} ;

class Main inherits IO {
    attr : A;
    func(val : B) : A { val };
  main() : Object { 
    {
        attr <- (new A);
        let blah : A <- func(attr) in
        out_string("Hello, world.\n") ;
    }
  } ;
} ; 
