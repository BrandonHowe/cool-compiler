class A {};

class Main {
    a : A <- new A;
    main() : Object {
    {
        case a of
            x: Int => 123;
        esac;
    }
    };
};