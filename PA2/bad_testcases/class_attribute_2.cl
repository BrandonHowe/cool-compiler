class A {
    feature : Int <- 5;
} ;

class Main inherits IO {
    a : A <- (new A);
    main() : Object {
        {
            out_int(a.feature());
        } 
    } ;
} ; 
