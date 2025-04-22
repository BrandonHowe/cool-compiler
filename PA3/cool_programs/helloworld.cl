class Main inherits IO
{
a : Int <- let x : Int <- 5 in
               case x of
                 a : Int => if a < 9 then 1 else 2 fi;
                 b : String => 10;
                 c : Object => 11;
               esac;
b : Int <- let x : Int <- 5 in
               case x of
                 a : Int => if a < 9 then 1 else 2 fi;
                 b : String => 10;
                 c : Object => 11;
               esac;
  main() : Object
  {
    123
  };
};