class Main inherits IO
{
  main() : Object
  {
    {
      let var : String <- "bad" in
	let var : String <- "good" in
	  out_string(var);

	  out_int(case "bad" of
      	var : String =>
      	  let var : String <- "good" in
            if var = "good" then 1 else 2 fi;
            esac);

      out_string( "\n" );
    }
  };
};