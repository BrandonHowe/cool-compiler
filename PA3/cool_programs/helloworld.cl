class Main inherits IO {
    main() : Object {
        let a : Int,
        b : Int,
        c : Int,
        d : Int,
        e : Int,
        counter : Int
        in {
            a <- in_int();
            b <- in_int();
            c <- in_int();
            d <- in_int();
            e <- in_int();
            counter <- 0;
            while counter < 5 loop {
                b <- a * 5;
                c <- a * b;
                d <- d - c;
                e <- d + c - b / a;
                counter <- counter + 1;
            } pool;
            a <- if (a < 0) then 0 - a else a fi;
            out_int(a);
            out_int(b);
            out_int(c);
            out_int(d);
            out_int(e);
        }
    };
};