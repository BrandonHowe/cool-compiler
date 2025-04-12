class Main inherits IO {
    io : IO <- new IO;
    main() : Object { let a : Int, b : Int, c : Int, d : Int in { a <- in_int(); b <- in_int(); if not a = b then { c <- in_int(); d <- in_int(); if not c = d then out_int(500) else out_int(999) fi; } else out_int(a / b) fi; } };
};