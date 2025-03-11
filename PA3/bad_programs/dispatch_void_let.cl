class A {
    blah() : SELF_TYPE { self };
};

class Main {
    main() : Object {
    {
        let a : A in a.blah();
    }
    };
};