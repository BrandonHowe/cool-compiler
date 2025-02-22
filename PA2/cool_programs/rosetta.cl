-- Seperator character: à

class List inherits IO {
  is_empty() : Bool { true };
  head() : String { { abort(); new String; } };
  tail() : List { { abort(); self; } };
  cons(i : String) : List {
    (new Cons).init(i, self)
  };
  contains(val : String) : Bool { false };
  length() : Int { 0 };
  element_at(idx : Int) : String { { abort(); new String; } };
  remove(val : String) : List { self };

  concat(list : List) : List { list };

	sort() : List { if is_empty() then self else tail() fi };

	insert(i : String) : List { if is_empty() then (new Cons).init(i, self) else tail() fi };

  print() : Object {
    {
      out_string("");
    }
  };

  print_nl() : Object {
    {
      out_string("");
    }
  };
};

class Cons inherits List {
  is_empty() : Bool { false };
  car : String;
  cdr : List;
  head()  : String { car };
  tail()  : List { cdr };

  init(i : String, rest : List) : List {
    {
      car <- i;
      cdr <- rest;
      self;
    }
  };

	sort() : List { (cdr.sort()).insert(car) };

  concat(list : List) : List {
    if cdr.is_empty()
    then { cdr <- list; self; }
    else { cdr <- cdr.concat(list); self; }
    fi
  };

  insert(i : String) : List {
		if i < car then
			(new Cons).init(i,self)
		else
			(new Cons).init(car,cdr.insert(i))
		fi
	};

  contains(val : String) : Bool {
    if car = val then true else cdr.contains(val) fi
  };

  length() : Int {
    1 + cdr.length()
  };

  element_at(idx : Int) : String {
    if idx = 0 then car else cdr.element_at(idx - 1) fi
  };

  remove(val : String) : List {
    if car = val
    then cdr
    else { cdr <- cdr.remove(val); self; }
    fi
  };

  print() : Object {
    {
      out_string(car);
      out_string(", ");
      cdr.print();
    }
  };

  print_nl() : Object {
    {
      out_string(car);
      out_string("\n");
      cdr.print_nl();
    }
  };
};

class StringPair inherits IO {
  left : String;
  right : String;

  init(fst : String, snd : String) : StringPair {
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

class Pair inherits IO {
  left : String;
  right : List;

  init(fst : String, snd : List) : Pair {
    {
      left <- fst;
      right <- snd;
      self;
    }
  };

  fst() : String { left };
  snd() : List { right };

  set_fst(val : String) : Object { left <- val };
  set_snd(val : List) : Object { right <- val };

  print() : Object {
    {
      out_string("(");
      out_string(left);
      out_string(", ");
      right.print();
      out_string(")");
    }
  };

  print_dict() : Object {
    {
      out_string(left);
      out_string(": ");
      right.print();
    }
  };
};

class EmptyDict inherits IO {
  car() : Pair { { abort(); new Pair; } };
  cdr() : EmptyDict { new EmptyDict };

  is_empty() : Bool { true };
  is_filled() : Bool { false };

  nuke(key : String) : EmptyDict { self };

  find(key : String) : List {
    {
      new List;
    }
  };

  contains(key : String) : Bool {
    false
  };

  add_pair(pair : Pair) : Dict {
    (let new_cell : Dict <- new Dict in
      new_cell.init(pair, self)
    )
  };

  add(pair : StringPair) : Dict {
    (let new_cell : Dict <- new Dict in
      new_cell.init((new Pair).init(pair.fst(), (new Cons).init(pair.snd(), new List)), self)
    )
  };

  set(key : String, value : List) : Object {
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
  is_filled() : Bool { true };

  init(hd : Pair, tl : EmptyDict) : Dict {
    {
      xcar <- hd;
      xcdr <- tl;
      self;
    }
  };

  car() : Pair { xcar };
  cdr() : EmptyDict { xcdr };

  nuke(key : String) : EmptyDict {
    if xcar.fst() = key
    then xcdr.nuke(key)
    else
    {
      -- out_string(xcar.fst());
      -- out_string(": ");
      -- xcar.snd().print();
      xcar.set_snd(xcar.snd().remove(key));
      -- out_string("-> ");
      -- xcar.snd().print();
      -- out_string("\n");
      xcdr <- xcdr.nuke(key);
      if xcar.snd().length() = 0
      then xcdr
      else self
      fi;
    }
    fi
  };

  find(key : String) : List {
    if xcar.fst() = key then xcar.snd() else xcdr.find(key) fi
  };

  contains(key : String) : Bool {
    if xcar.fst() = key then true else xcdr.contains(key) fi
  };

  add_pair(pair : Pair) : Dict {
    if self.contains(pair.fst())
    then {
      set(pair.fst(), pair.snd());
      self;
    }
    else
      (let new_cell : Dict <- new Dict in
        new_cell.init(pair, self)
      )
    fi
  };

  add(pair : StringPair) : Dict {
    if self.contains(pair.fst())
    then {
      set(pair.fst(), (new Cons).init(pair.snd(), self.find(pair.fst())));
      self;
    }
    else
      (let new_cell : Dict <- new Dict in
        new_cell.init((new Pair).init(pair.fst(), (new Cons).init(pair.snd(), new List)), self)
      )
    fi
  };

  set(key : String, value : List) : Object {
    if xcar.fst() = key
    then xcar.set_snd(value)
    else
      if xcdr.is_empty()
      then xcdr <- (new EmptyDict).add_pair((new Pair).init(key, value))
      else xcdr.set(key, value)
      fi
    fi
  };

  print_base() : Object {
    {
      xcar.print_dict();
      if xcdr.is_empty()
      then { out_string(""); }
      else { out_string("| "); xcdr.print_base(); }
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
    let str1 : String <- in_string() in
    let str2 : String <- in_string() in
    let seen_strs : List <- new List in
    let dict : EmptyDict <- new EmptyDict in
    let rev_dict : EmptyDict <- new EmptyDict in
    {
      while 0 < str1.length() loop
      {
        let pair : StringPair <- (new StringPair).init(str1, str2) in
        {
          dict <- dict.add(pair);
          -- dict.print();
          -- out_string("\n");
        };
        let rev_pair : StringPair <- (new StringPair).init(str2, str1) in
        {
          rev_dict <- rev_dict.add(rev_pair);
          -- rev_dict.print();
          -- out_string("\n");
        };

        if seen_strs.contains(str1)
        then seen_strs <- seen_strs
        else seen_strs <- seen_strs.cons(str1)
        fi;

        if seen_strs.contains(str2)
        then seen_strs <- seen_strs
        else seen_strs <- seen_strs.cons(str2)
        fi;

        -- seen_strs.print();
        -- out_string("\n");
        
        iter <- iter + 1;

        str1 <- in_string();
        str2 <- in_string();
      } pool;

      let sorted : List <- (new List) in
      let starters : List <- (new List) in
      let running : Bool <- true in
      let cycle : Bool <- false in
      let i : Int <- 0 in
      {
        while running = true loop
        {
          i <- 0;
          while i < seen_strs.length() loop
          {
            let el : String <- seen_strs.element_at(i) in
            if dict.contains(el)
            then starters <- starters
            else
              if sorted.contains(el)
              then starters <- starters
              else starters <- (new Cons).init(el, starters)
              fi
            fi;
            i <- i + 1;
          } pool;

          if starters.length() = 0
          then { running <- false; cycle <- dict.is_empty(); }
          else { running <- running; }
          fi;

          starters <- starters.sort();
          sorted <- sorted.concat(starters);

          while 0 < starters.length() loop
          {
            let el : String <- starters.head() in
            {
              dict <- dict.nuke(el);
              rev_dict <- rev_dict.nuke(el);
              starters <- starters.tail();
            };
          }
          pool;

          starters <- new List;
        }
        pool;
        if cycle
        then { sorted.print_nl(); }
        else { out_string("cycle"); }
        fi;
      };
    }
  } ;
} ;
