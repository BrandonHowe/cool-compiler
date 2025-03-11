class Main inherits IO
{
  print( value : Int ) : Object {{
      out_int( value );
      out_string( "\n" );
      self;
  }};

  x : Object <- print( 1 );
  y : Object <- print( 2 );
  z : Object <- print( 3 );
  c : Object <- print( 4 );
  b : Object <- print( 5 );
  a : Object <- print( 6 );

  main() : Object { 123 };
};