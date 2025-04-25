class Main inherits IO {
    main() : Object {
    out_int(let
          i : Int,
          j : Int,
          k : Int,
          ctI : Int <- 0,
          ctJ : Int <- 0,
          ctK : Int <- 0
        in {
          i <- 0;
          while i < 10 loop {
            j <- 0;
            while j < 10 loop {
              j <- j + 1;
              ctJ <- ctJ + 1;
            } pool;
            i <- i + 1;
            ctI <- ctI + 1;
          } pool;
          ctJ;
        })
    };
};