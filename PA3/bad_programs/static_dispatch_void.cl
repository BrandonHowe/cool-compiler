class A {
    blah() : SELF_TYPE { self };
};

class B inherits A {

};

class Main {
    b : B;
    main() : Object {
    {
        b@A.blah();
    }
    };
};