class X inherits IO {
    x : Int <- 1;
    print() : Int {{ out_int(x); 0; }};

    blah : Int <- (let a : Int <- x in { x <- x + 2; a; });

    i : Object <- print();
};

class Main {
    x : X <- new X;

    main() : Object { 123 };
};