class Main {
    main() : Object {
        let x : Int <- 5 in case x + 1 of
            a : Int => a + 7;
            b : Object => x + 9;
        esac
    };
};