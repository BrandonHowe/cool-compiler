class A inherits IO
{
  print_type_name( thing : Object ) : Object
  {
    {
      out_string( thing.type_name() );
      out_string( "\n" );
    }
  };

  test() : Object
  {
    {
      print_type_name(new A);
      print_type_name(new B);
      print_type_name(new Main);

      let poly : A <- new B in
	  print_type_name(poly);

      print_type_name(self);
    }
  };
};

class B inherits A {};

class Main
{
  main() : Object { (new B).test() };
};