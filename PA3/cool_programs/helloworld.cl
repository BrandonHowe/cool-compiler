class A inherits IO
{
  print() : Object
  {
    out_string("A\n")
  };
};


class B inherits A
{
  print() : Object
  {
    out_string("B\n")
  };
};


class Main
{
  main() : Object
  {
    {
      let me : B <- new B in
      {
    	me@B.print();
    	me@A.print();
      };
    }
  };
};