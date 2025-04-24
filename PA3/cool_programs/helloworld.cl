class A inherits IO {
    h : Int <- 1;
    doh() : Int { (let i: Int <- h in { h <- h + 1; i; } ) };
};

class B inherits A {
    a : B <- case self of
        n : B => n;
    esac;
    f() : Object { a@A.doh() };
};

class Main inherits IO {
    a : A <- new A;
    b : B <- new B;
    main() : Object { b.f() };
};