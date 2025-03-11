class Main inherits IO {
  main(): IO {
	let x: Int <- 5 in out_int((x <- 1) + ((x <- x+2) + (3 + (4 + (5 + (6 + (8 + (x + 9))))))))
  };
};