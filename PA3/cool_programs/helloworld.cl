class Main inherits IO {
    main() : Object {{
        let x : Int <- 1 in while x + 1 < x loop { x <- x + 1; x <- x + 1; while 100 < 0 loop x <- x + 1 pool; } pool;
    }};
};