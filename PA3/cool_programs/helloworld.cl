class Main inherits IO {
    main() : Object {{
        let x : Int <- 1 in { out_int(if 1 < 2 then if 4 < 3 then { x <- x + 1; } else { 6; } fi else { 5; } fi); out_int(x); };
        --let a : Int, b : Int, c : Int, d : Int in { a <- in_int(); b <- in_int(); if not a = b then { c <- in_int(); d <- in_int(); if not c = d then out_int(500) else out_int(999) fi; } else out_int(a / b) fi; };
        --let x : Int <- 1 in { out_int(if 1 < 2 then 5 else { let y : Int <- 5 in x <- x + 1; } fi); out_int(x); };
        --let x : Int, a : Int in { x <- in_int(); while a < x loop { a <- a + 1; out_int(a / 5); } pool; };
        --let x : Int <- 1 in { if 1 < 2 then if 5 < 3 then x <- x + 10 else { x <- x + 20; let y : Int <- 5 in x <- x + y; } fi else x <- x + 2 fi; out_int(x); };
        -- let x : Int <- 1 in while x < 8 loop { x <- x + 1; x <- x + 1; out_int(x); } pool;
    }};
};