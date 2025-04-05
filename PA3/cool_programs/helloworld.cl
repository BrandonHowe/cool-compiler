class Main inherits IO {
    str : String <- "asdf";

    len() : Int { str.length() };

    main() : Object {{ out_int(str.length()); out_int(len()); }};
};