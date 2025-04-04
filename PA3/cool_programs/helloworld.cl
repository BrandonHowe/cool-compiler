class Main inherits IO {
    x : Object <- 5;
    add(a : Int, b : Int) : Int { a <- a + b };
    main() : Object {{
        out_int(add(5, 6));
    }};
};