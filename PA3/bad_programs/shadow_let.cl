class Main inherits IO
{
  main() : Object
  {
    {
      let var : String <- "bad" in
	let var : String <- "good" in
	  out_string(var);
      out_string("\n");
    }
  };
};