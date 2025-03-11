class Main inherits IO
{
    var : String <- "blah";

    pluh(var : String) : Object { out_string(var) };

    pluh2(var : String) : Object { case "good" of var : String => out_string(var); esac };

  main() : Object
  {
    {
	case "good" of
	  var : String =>
	    out_string( var );
	esac;

      pluh("booger");
      pluh2("tomp");
    }
  };
};