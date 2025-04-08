class Main {
    main() : Object {{
        (*let x : Int <- (case 500 of
            a : Int => let b : Int <- a + 500 in case b of
                c : Int => c + 5;
            esac;
            b : Object => { 500; };
        esac) in 5 + x;*)
        let x : Int <- case 500 of a : Int => 1000; esac in 5 + x;
    }};
};