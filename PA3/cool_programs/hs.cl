(* hairy  . . .*)

class A inherits IO {

     h : Int <- 1;

     g : B  <- case self of
		     	n : A => (new B);
		     	n : C => (new D);
			n : B  => (new C);
			n : D => n;
		  esac;

     i : Object <- printh();

     printh() : Int { { out_int(h); 0; } };

     doh() : Int { (let i: Int <- h in { h <- h + 1; i; } ) };
};

class B inherits A {
     a : C <- case self of
		      n : C => (new D);
		      n : B => (new C);
		      n : D => n;
   	         esac;

   	 b : Int <- doh() + printh();

     --b : Int <- a.doh() + g.doh() + doh() + printh();

     --doh : Int <- (let i : Int <- h in { h <- h + 2; i; } );

     --doh() : Int { (let i : Int <- h in { h <- h + 2; i; } ) };

};

class C inherits B {

     e : D <- case self of
		  n : C => (new D);
		  n : D => n;
		esac;

    f : Int <- doh() + printh();

     --f : Int <- a@A.doh() + g.doh() + e.doh() + doh() + printh();

};

class D inherits C {

     c : Int <- doh();

     d : Object <- printh();
};

(* scary . . . *)
class Main inherits IO {
  a : A <- new A;
  b : B <- new B;
  c : C <- new C;
  d : D <- new D;

  f : Int <- let x : Int <- 5 in x;

  g : Int <- if 6 < 7 then 9 else 3 fi;

  main(): String { { out_string("\n") ; "do nothing" ; } };

};





