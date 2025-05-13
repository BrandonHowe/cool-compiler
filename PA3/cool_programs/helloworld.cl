class Main inherits IO {
    a : Int <- 5;
    b : Int <- 6;
    c : Int <- 7;
    main() : Object {
        out_int(a + b * c)
        --let i : Int <- 0 in while i < 5 loop { out_int(i); i <- i + 1; } pool
    };
};