class Silly {
	copy(val : SELF_TYPE) : SELF_TYPE { self };
};

class Sally inherits Silly { };

class Main {
	x : Sally <- (new Sally).copy((new Sally));

	main() : Sally { x };
};
