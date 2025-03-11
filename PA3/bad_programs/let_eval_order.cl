class Main inherits IO {
    print(a : Int) : Int {{ out_int(a); out_string("\n"); a; }};

    main() : Object {
        let a : Int <- print(1), b : Int <- print(2), a : Int <- print(3), d : Int <- print(4) in
        print(a)
    };
};