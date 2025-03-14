class Main inherits IO {
    main() : Object {
        let a : Int, b : String, c : Bool, d : IO in {
            if isvoid a then out_string("A is void") else 12 fi;
            if isvoid b then out_string("B is void") else 12 fi;
            if isvoid c then out_string("C is void") else 12 fi;
            if isvoid d then out_string("D is void") else 12 fi;

            let e : Int, f : String, g : Bool, h : IO in
            {
                if isvoid e then out_string("E is void") else 12 fi;
                if isvoid f then out_string("F is void") else 12 fi;
                if isvoid g then out_string("G is void") else 12 fi;
                if isvoid h then out_string("H is void") else 12 fi;
            };
        }
    };
};