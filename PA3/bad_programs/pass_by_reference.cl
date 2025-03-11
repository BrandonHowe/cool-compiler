class Main inherits IO {
    inc(x : Int) : Int {{ x <- x + 1; x; }};
    main() : Object {
    {
        let b : Int <- 5 in
        {
            out_int(b);
            out_int(inc(b));
            out_int(b);
        };
    }
    };
};