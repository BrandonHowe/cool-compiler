class A {};
class B {};

class Main {
    a : A;
    b : B;

	main():Object {{
		if (true = false) then abort() else 0 fi;
		if (true = true) then 0 else abort() fi;
		if ("poop" = "poop".copy()) then 0 else abort() fi;
		let a:String in if (a = "") then 0 else abort() fi;
		if 5 = 6 then abort() else 0 fi;
		if a = b then 0 else abort() fi;
		let b : A <- new A in if a = b then abort() else 0 fi;
	}};

};