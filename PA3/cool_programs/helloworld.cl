class Main inherits IO {
    x : Object <- 5;
    a() : Object {{ x <- while true loop 5 pool; }};
    main() : Object {{
        out_int(case x of
            c : Object => 13;
            a : Int => 9;
            b : String => 11;
        esac);
    }};
};