class Main inherits IO {
    main() : Object {
        out_int(case 5 of
            a : Int => case a of
                b : Object => 7;
            esac;
            b : Object => 9;
        esac)
    };
};