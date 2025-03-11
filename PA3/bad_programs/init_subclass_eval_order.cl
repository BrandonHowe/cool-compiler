class Base inherits IO
{
  print( value : Int ) : Object {{
      out_int( value );
      out_string( "\n" );
      self;
  }};

  x : Object <- print( 1 );
  b : Object <- print( 2 );
};


class Main inherits Base
{
  y : Object <- print( 3 );
  z : Object <- print( 4 );
  c : Object <- print( 5 );

  main() : Object { 123 };
};