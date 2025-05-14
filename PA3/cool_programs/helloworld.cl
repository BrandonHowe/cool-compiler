class Main inherits IO {
    a : Int <- 5;
    b : Int <- 6;
    c : Int <- 7;
    main() : Object {
        let d : Int <- a in { out_int(d * 2); out_int(d * 3); }
        --let i : Int <- 0 in while i < 5 loop { out_int(i); i <- i + 1; } pool
    };
};