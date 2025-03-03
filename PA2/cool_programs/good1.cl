class A {
    blah() : SELF_TYPE { self };
};

class B inherits A {
    a : A;

    blop() : A {{
        a <- (new B).blah();
        a;
    }};
};

class Main inherits IO{
    x: Int;
    main(): Object {
        {
            let x : String<- "test" in x.length();
            out_int(x);
        }
    };
};