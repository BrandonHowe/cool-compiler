class Main inherits IO {
  main() : Object {
    let b : Bool <- true, z : Int <- in_int(), x : Int <- if b then 1 else ~1 fi, y : Int <- x + 3 in {
     out_string("x: ");
     out_int(x);
     out_string("\nb: ");
     out_string(if b then "true" else "false" fi);
     out_string("\ny: ");
     out_int(y);
     out_string("\nz: ");
     out_int(z);
    }
  };
};