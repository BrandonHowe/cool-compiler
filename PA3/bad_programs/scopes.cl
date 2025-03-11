class A inherits IO {
	x : Int;
	y : Int <- 4;
};

class Main inherits A {
	z : Int <- 23;
	blah(q : Int, z : Int) : Int {{
		let z:Int <- z + y in print(z);
	        y <- y + 4;
	        let y:Int <- z + y  in y;
	}};
	print(z: Int) : SELF_TYPE {{
		out_string("z = "); 
		out_int(z); 
		out_string("\n"); 
	}};
	main() : A {{
		print(z);
		let z:Int <- blah(5,z+2) in
		print(z);
	}};
};