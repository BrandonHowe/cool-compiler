class Main inherits IO{
 x: SELF_TYPE;
 main(): Object {{
		   let x : String<- "test" in x.length();
		   out_int(x);
                }};
};