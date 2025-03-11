-- Seperator character: à

class List inherits IO {
  is_nil() : Bool { true };
  head() : String { { abort(); new String; } };
  tail() : List { { abort(); self; } };
  cons(i : String) : List {
    (new Cons).init(i, self)
  };

  print() : Object {
    {
      out_string("");
    }
  };
};

class Cons inherits List {
  car : String;
  cdr : List;

  init(i : String, rest : List) : List {
    {
      car <- i;
      cdr <- rest;
      self;
    }
  };

  print() : Object {
    {
      out_string(car);
      out_string(", ");
      cdr.print();
    }
  };
};

class StringArray inherits IO {
  arr : String;

  init(str : String) : StringArray {
    {
      arr <- str;
      self;
    }
  };

  contains(target : String) : Bool {
    let i : Int <- 0 in
    let start : Int <- 0 in
    let len : Int <- 0 in
    let found : Bool <- false in
    {
      while i < arr.length() - 1 loop
      {
        if arr.substr(i, 2) = "à"
        then {
          (let str : String <- arr.substr(start, len) in
          {
            if str = target
            then found <- true
            else found <- found
            fi;
          });
          i <- i + 1;
          start <- i + 1;
          len <- 0;
        }
        else
          len <- len + 1
        fi;
        i <- i + 1;
      }
      pool;
      (let str : String <- arr.substr(start, arr.length() - start) in
      {
        if str = target
        then found <- true
        else found <- found
        fi;
      });
      found;
    }
  };
};

class Pair inherits IO {
  left : String;
  right : String;

  init(fst : String, snd : String) : Pair {
    {
      left <- fst;
      right <- snd;
      self;
    }
  };

  fst() : String { left };
  snd() : String { right };

  set_fst(val : String) : Object { left <- val };
  set_snd(val : String) : Object { right <- val };

  print() : Object {
    {
      out_string("(");
      out_string(left);
      out_string(", ");
      out_string(right);
      out_string(")");
    }
  };

  print_dict() : Object {
    {
      out_string(left);
      out_string(": ");
      out_string(right);
    }
  };
};

class EmptyDict inherits IO {
  is_empty() : Bool { true };

  find(key : String) : String {
    {
      abort();
      new String;
    }
  };

  contains(key : String) : Bool {
    false
  };

  add(pair : Pair) : Dict {
    (let new_cell : Dict <- new Dict in
      new_cell.init(pair, self)
    )
  };

  set(key : String, value : String) : Object {
    abort()
  };

  print() : Object {
    {
      out_string("{}");
    }
  };

  print_base() : Object {
    print()
  };
};

class Dict inherits EmptyDict {
  xcar : Pair;
  xcdr : EmptyDict;

  is_empty() : Bool { false };

  init(hd : Pair, tl : EmptyDict) : Dict {
    {
      xcar <- hd;
      xcdr <- tl;
      self;
    }
  };

  car() : Pair { xcar };
  cdr() : Pair { xcar };

  find(key : String) : String {
    if xcar.fst() = key then xcar.snd() else xcdr.find(key) fi
  };

  contains(key : String) : Bool {
    if xcar.fst() = key then true else xcdr.contains(key) fi
  };

  add(pair : Pair) : Dict {
    if self.contains(pair.fst())
    then {
      set(pair.fst(), self.find(pair.fst()).concat("à").concat(pair.snd()));
      self;
    }
    else
      (let new_cell : Dict <- new Dict in
        new_cell.init(pair, self)
      )
    fi
  };

  set(key : String, value : String) : Object {
    if xcar.fst() = key
    then xcar.set_snd(value)
    else
      if xcdr.is_empty()
      then xcdr <- (new EmptyDict).add((new Pair).init(key, value))
      else xcdr.set(key, value)
      fi
    fi
  };

  print_base() : Object {
    {
      xcar.print_dict();
      if xcdr.is_empty()
      then { out_string(""); }
      else { out_string(", "); xcdr.print_base(); }
      fi;
    }
  };

  print() : Object {
    {
      out_string("{");
      print_base();
      out_string("}");
    }
  };
};

class Main inherits IO {
  main() : Object { 
    let iter : Int <- 0 in
    let str1 : String <- "" in
    let str2 : String <- "" in
    let seen_strs : List <- new List in
    let dict : EmptyDict <- new EmptyDict in
    let rev_dict : EmptyDict <- new EmptyDict in
    while 0 <= iter loop
    {
      str1 <- in_string();
      str2 <- in_string();
      let pair : Pair <- (new Pair).init(str1, str2) in
      {
        dict <- dict.add(pair);
        dict.print();
        out_string("\n");
      };
      let rev_pair : Pair <- (new Pair).init(str2, str1) in
      {
        rev_dict <- rev_dict.add(rev_pair);
        rev_dict.print();
        out_string("\n");
      };

      seen_strs <- seen_strs.cons(str1).cons(str2);
      seen_strs.print();
      out_string("\n");
      
      iter <- iter + 1;
    } pool
  } ;
} ; 

(*
      if 0 < iter
      then
      {
        if (new StringArray).init(seen_str).contains(str1)
        then seen_str <- seen_str
        else seen_str <- seen_str.concat("à").concat(str1)
        fi;
        if (new StringArray).init(seen_str).contains(str2)
        then seen_str <- seen_str
        else seen_str <- seen_str.concat("à").concat(str2)
        fi;
      }
      else
        seen_str <- str1.concat("à").concat(str2)
      fi;
      out_string("Seen str: ".concat(seen_str));
      out_string("\n");
*)