class A {};
class B {};

class Main inherits IO {
    a : A <- new A;
    b : B <- new B;
    main() : Object {
    {
    out_string(if a < b then "yass" else "nahh" fi);
    out_string(if b < a then "yass" else "nahh" fi);
    }
    };
};