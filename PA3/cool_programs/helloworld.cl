class Main inherits IO
{
  main() : Object
  {{
    let x : Int, a : Int in { x <- in_int(); while a < x loop { a <- a + 1; out_int(a / 5); } pool; };
  }};
};