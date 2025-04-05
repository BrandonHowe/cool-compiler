class Main inherits IO {
    main() : Object {
        let val : Int <- 5 in
        case val of
            a : Object => 123;
            b : Int => b;
            c : String => 789;
        esac
    };
};