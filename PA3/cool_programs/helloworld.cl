class ZZ {
    a : Int <- 5;
    b : Object <- new Object;
};

class Main inherits IO {
    x : Int;
    io : IO <- new IO;
    --main() : Object { while x < 100 loop x <- x + 1 pool };
    --main() : Object { if not true then io.out_int(123) else io.out_int(~246) fi };
    main() : Object { let x : Int, a : Int in { x <- in_int(); while a < x loop { a <- a + 1; out_int(a / 5); } pool; } };
    --main() : Object {{ if (5 = 6) = (7 = 7) then io.out_int(1) else io.out_int(0) fi; }};
    --main() : Object {{ let a : Int <- 4 + 5 + 8 in out_int(a); }};
};