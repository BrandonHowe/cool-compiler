class Main inherits IO
{
  print( value : Int ) : Int {{
      out_int( value );
      out_string( "\n" );
      value;
  }};

  main() : Object {{
      print( 1 ) + print( 2 );
      print( 3 ) - print( 4 );
      print( 5 ) * print( 6 );
      print( 7 ) / print( 8 );
      print( 9 ) = print( 10 );
      print( 11 ) < print( 12 );
      print( 13 ) <= print( 14 );
  }};
};