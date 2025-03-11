class A {};

class Main inherits IO {
    a : A <- new A;
    main() : Object {
    {
    out_int(
        case a of
            x: Object => 456;
            ax: A => 123;
        esac
        );
    out_string("\n");
    }
    };
};