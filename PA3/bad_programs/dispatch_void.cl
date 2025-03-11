class A {
    blah() : SELF_TYPE { self };
};

class Main {
    a : A;
    main() : Object {
    {
        a.blah();
    }
    };
};