class B inherits A {
    attr2 : Int <- 19;
};

class A inherits C {
    attr : Int <- 8;
};

class C inherits B {
    attr3 : Int <- 45;
};

class Main inherits IO {
    a : Int <- 5;
  main() : Object {
    let str : String <- "Hello, world.\n" in
    out_string(str)
  } ;
} ; 
