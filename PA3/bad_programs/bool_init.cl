class Main inherits IO {
    main() : Object {
        let t : Bool <- true, f : Bool <- false, t1 : Object <- true, f1 : Object <- false, b1 : Bool, b2 : Object in
        {
            out_string(t.type_name());
            out_string("\n");

            out_string(f.type_name());
            out_string("\n");

            out_string(t1.type_name());
            out_string("\n");

            b1 <- f.copy();
            out_string(b1.type_name());
            out_string("\n");

            b2 <- f1.copy();
            out_string(b2.type_name());
            out_string("\n");
        }
    };
};