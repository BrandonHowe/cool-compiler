class Main inherits IO {
    print(v : Int): Int {{ out_int(v); v; }};

    main(): Object {
        if print(2) < print(1) then print(3) else print(4) fi
    };
};