class Main inherits IO {
    main() : Object { let a : Int <- 0 in while a < 5 loop { a <- a + 1; out_int(a); } pool };
};