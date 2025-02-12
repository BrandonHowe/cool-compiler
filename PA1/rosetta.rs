use std::collections::HashMap;
use std::io::{self, BufRead};

fn main() {
    let stdin = io::stdin();
    let mut lines = Vec::new();

    for line in stdin.lock().lines() {
        match line {
            Ok(l) => lines.push(l.trim().to_string()),
            Err(_) => break
        }
    }
    let mut line_set = Vec::new();

    for line in &lines {
        if !line_set.contains(&line) {
            line_set.push(line);
        }
    }

    let mut dependencies: HashMap<usize, Vec<usize>> = HashMap::new();
    let mut reverse_dependencies: HashMap<usize, Vec<usize>> = HashMap::new();

    for i in (0..lines.len()).step_by(2) {
        let idx1 = line_set.iter().position(|&x| x == &lines[i]).unwrap();
        let idx2 = line_set.iter().position(|&x| x == &lines[i + 1]).unwrap();
        
        if !dependencies.contains_key(&idx2) {
            dependencies.insert(idx2, Vec::new());
        }
        let dep_vec = dependencies.get_mut(&idx2).unwrap();
        dep_vec.push(idx1);

        if !reverse_dependencies.contains_key(&idx1) {
            reverse_dependencies.insert(idx1, Vec::new());
        }
        let revdep_vec = reverse_dependencies.get_mut(&idx1).unwrap();
        revdep_vec.push(idx2);
    }

    let mut l: Vec<usize> = Vec::new();
    let mut s = Vec::new();
    for i in 0..line_set.len() {
        if !reverse_dependencies.contains_key(&i) {
            s.push(i);
        }
    }
    s.sort_by(|&a, &b| line_set[b].cmp(&line_set[a]));

    while s.len() > 0 {
        let n = s.pop().unwrap();
        l.push(n);
        if !dependencies.contains_key(&n) { continue; }

        let n_deps = dependencies.get(&n).unwrap();
        for m in n_deps {
            if reverse_dependencies.contains_key(m) {
                let arr = reverse_dependencies.get_mut(m).unwrap();
                arr.retain(|&x| x != n);
            }
            if reverse_dependencies.contains_key(m) {
                if reverse_dependencies.get(m).unwrap().len() == 0 {
                    s.push(*m);
                    s.sort_by(|&a, &b| line_set[b].cmp(&line_set[a]));
                }
            }
        }

        dependencies.remove(&n);
    }

    let mut has_edges = false;
    for key in 0..line_set.len() {
        if let Some(deps) = dependencies.get(&key) {
            if !deps.is_empty() {
                has_edges = true;
                break;
            }
        }
    }
    
    if has_edges {
        println!("cycle");
    } else {
        for e in l {
            println!("{}", line_set[e]);
        }
    }
}
