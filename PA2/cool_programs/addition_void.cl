class Silly {
	copy() : SELF_TYPE { self };
};

class Sally inherits Silly {
    a : Int;

    init() : Sally {
        let blah : Int <- a + 5 in
        let blap : Int <- a + "asdfasdf" in
        let blag : Int <- a + true in
        let asdf : String <- a in
        self
    };
};

class Main {
	x : Sally <- (new Sally).copy();

	main() : Sally { x };
};