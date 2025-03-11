class Main inherits IO {
    print(v : Int): Int {{ out_int(v); v; }};

    main(): Object {
        while print(5) < print(4) loop
            print(6)
        pool
    };
};