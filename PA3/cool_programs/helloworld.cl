class Main inherits IO {
    a : Int <- 5;
    b : Int <- 8;
    constant() : Int {{ case 5 of a : Int => 123; b : Object => 246; esac; }};
--    constant() : Object {{ a; 5; b; }};
--    constant() : Object {{ while true loop a <- a + 1 pool; 1234; }};
    trash(x : Object, y : Object, z : Object) : Int { 1 };
    main() : Object {{
        out_string("Hello world!");
        out_int(constant());
    }};
};

class ZZ {
    constant() : ZZ { self };
};