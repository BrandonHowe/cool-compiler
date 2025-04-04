class Main inherits IO {
    x : Object <- 5;
    add(a : Int, b : Int) : Int { a <- a + b };
    main() : Object {{
        case x of
            a : Object => 5;
            b : Int => 7;
        esac;
    }};
};