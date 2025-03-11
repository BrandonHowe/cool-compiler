class Main inherits IO
{
  print( value : Int ) : Object {{
      out_int( value );
      out_string( "\n" );
  }};

  blah( a : Object, b : Object, c : Object ) : Object { self };

  main() : Object
  {
    blah( print( 1 ), print( 2 ), print( 3 ) )
  };
};