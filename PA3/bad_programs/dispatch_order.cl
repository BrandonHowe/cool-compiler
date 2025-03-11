class Main inherits IO
{
  print( value : Int ) : Main {{
      out_int( value );
      out_string( "\n" );
      self;
  }};

  blah(a : Object) : Object { self };

  main() : Object { print( 2 ).blah( print( 1 ) ) };
};