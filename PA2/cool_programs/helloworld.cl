class A inherits IO {
    --addOne(val : Int) : Int { 6 };

    bleh() : Object { out_string("bloop") };
};

class Main inherits IO {
    addOne(val : Int) : Int { 6 };

    --a : Int <- 1234;
    --b : Int <- 1234 + 5678;
  main() : Object {
    --let str : String <- "Hello, world.\n" in
    --out_string(str)
    {
        let x : Int <- 123, y : String <- "poop" in x + y;
        --addOne(5);
        --out_string("blah");
    }
  } ;
} ; 
