class Main inherits IO {
    io : IO <- new IO;
    main() : Object { out_string("my string") };
    --main() : Object { let a : Int, b : Int, c : Int, d : Int in { a <- in_int(); b <- in_int(); if not a = b then { c <- in_int(); d <- in_int(); if not c = d then out_int(500) else out_int(999) fi; } else out_int(a / b) fi; } };
    --main() : Object { while x < 100 loop x <- x + 1 pool };
    --main() : Object { if not true then io.out_int(123) else io.out_int(~246) fi };
    --main() : Object { let x : Int, a : Int in { x <- in_int(); while a < x loop { a <- a + 1; out_int(a / 5); } pool; } };
    --main() : Object {{ if (5 = 6) = (7 = 7) then io.out_int(1) else io.out_int(0) fi; }};
    --main() : Object {{ let a : Int <- 4 + 5 + 8 in out_int(a); }};
};