class A {
    fard(a : B) : B {
        a.jump()
        --(new B).jump()
    };
};

class B inherits A {
    jump() : SELF_TYPE { self };
};

class Main inherits IO {
  main() : Int {
    {
        123;
    }
  } ;
} ;
