class Main inherits IO
{
  main() : Object
  {
    {
      let var : String <- "bad" in
	let var : String <- "good" in
	  out_string(var);

	  case "bad" of
      	var : String =>
      	  let var : String <- "good" in
      	    out_string( var );
            esac;

      out_string( "\n" );
    }
  };
};