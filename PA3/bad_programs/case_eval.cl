class Main inherits IO {
    print(v : Int): Int {{ out_int(v); v; }};

    main(): Object {
        out_int(case 5 of
            x : Object => print(6);
            a : Int => print(7);
        esac)
    };
};