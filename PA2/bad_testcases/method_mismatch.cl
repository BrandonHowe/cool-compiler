class A {
    method() : Int {
        5
    } ;
} ;

class B inherits A {
    method() : Bool {
        true
    } ;
} ;

class C inherits A {
    method(str : String) : Int {
        5
    } ;
} ;

class Main inherits IO {
  main() : Object { 
    out_string("Hello, world.\n") 
  } ;
} ; 
