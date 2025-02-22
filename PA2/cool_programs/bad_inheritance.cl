class A {
    a: Int;
    b: Int;
    add(x: Int, y: Int) : Int {
        {
            a <- x;
            b <- y;
            a + b;
        }
    };
};

class D1 inherits A {
    add(x: Bool, y: Int) : Int {
        {
            a <- x;
            b <- y;
            a - b;
        }
    };
};

class D3 inherits A {
    add(x: Int, y: Int) : Bool {
        {
            a <- x;
            b <- y;
            a - b;
            true;
        }
    };
};


class Main {
    main(): Int {
        0
    };
};