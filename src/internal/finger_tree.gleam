//// Link to FingerTree description: https://www.staff.city.ac.uk/~ross/papers/FingerTree.html

import gleam/option.{type Option, None, Some}
import gleam/result

/// Finger tree implementation 
pub opaque type FingerTree(u) {
  Empty
  Single(u)
  Deep(size: Int, Finger(u), FingerTree(Node(u)), Finger(u))
}

type Finger(u) {
  One(u)
  Two(u, u)
  Three(u, u, u)
  Four(u, u, u, u)
}

type Node(u) {
  Node1(u)
  Node2(u, u)
  Node3(u, u, u)
}

pub fn single(u: u) -> FingerTree(u) {
  Single(u)
}

pub fn unshift(tree: FingerTree(u), a: u) -> FingerTree(u) {
  case tree {
    Empty -> Single(a)
    Single(b) -> Deep(2, One(a), Empty, One(b))
    Deep(s, One(b), m, sf) -> Deep(s + 1, Two(a, b), m, sf)
    Deep(s, Two(b, c), m, sf) -> Deep(s + 1, Three(a, b, c), m, sf)
    Deep(s, Three(b, c, d), m, sf) -> Deep(s + 1, Four(a, b, c, d), m, sf)
    Deep(s, Four(b, c, d, e), Empty, sf) ->
      Deep(s + 1, Two(a, b), Single(Node3(c, d, e)), sf)
    Deep(s, Four(b, c, d, e), Single(v), sf) ->
      Deep(s + 1, Two(a, b), Deep(3, One(Node3(c, d, e)), Empty, One(v)), sf)
    Deep(s, Four(b, c, d, e), v, sf) ->
      Deep(s + 1, Two(a, b), unshift_node(v, Node3(c, d, e)), sf)
  }
}

fn unshift_node(tree: FingerTree(a), node: a) -> FingerTree(a) {
  tree |> unshift(node)
}

pub fn push(tree: FingerTree(u), a: u) -> FingerTree(u) {
  case tree {
    Empty -> Single(a)
    Single(b) -> Deep(2, One(b), Empty, One(a))
    Deep(s, pr, m, One(b)) -> Deep(s + 1, pr, m, Two(b, a))
    Deep(s, pr, m, Two(c, b)) -> Deep(s + 1, pr, m, Three(c, b, a))
    Deep(s, pr, m, Three(d, c, b)) -> Deep(s + 1, pr, m, Four(d, c, b, a))
    Deep(s, pr, m, Four(e, d, c, b)) ->
      Deep(s + 1, pr, do_push(m, Node3(e, d, c)), Two(b, a))
  }
}

fn do_push(tree: FingerTree(Node(a)), node: Node(a)) -> FingerTree(Node(a)) {
  tree |> push(node)
}

pub fn reducer(tree: FingerTree(u), acc: v, r_fn: fn(v, u) -> v) -> v {
  case tree {
    Empty -> acc
    Single(u) -> r_fn(acc, u)
    Deep(_, pr, m, sf) -> {
      let acc = reducer_finger(sf, acc, r_fn)
      let acc = reducer_node(m, acc, r_fn)
      reducer_finger(pr, acc, r_fn)
    }
  }
}

fn reducer_finger(finger: Finger(u), acc: v, r_fn: fn(v, u) -> v) -> v {
  case finger {
    One(u) -> r_fn(acc, u)
    Two(v, u) -> acc |> r_fn(u) |> r_fn(v)
    Three(w, v, u) -> acc |> r_fn(u) |> r_fn(v) |> r_fn(w)
    Four(x, w, v, u) -> acc |> r_fn(u) |> r_fn(v) |> r_fn(w) |> r_fn(x)
  }
}

fn reducer_node(node: FingerTree(Node(u)), acc: v, r_fn: fn(v, u) -> v) -> v {
  use acc, node <- reducer(node, acc)
  case node {
    Node1(u) -> r_fn(acc, u)
    Node2(v, u) -> acc |> r_fn(u) |> r_fn(v)
    Node3(w, v, u) -> acc |> r_fn(u) |> r_fn(v) |> r_fn(w)
  }
}

pub fn reducel(tree: FingerTree(u), acc: v, r_fn: fn(v, u) -> v) -> v {
  case tree {
    Empty -> acc
    Single(u) -> r_fn(acc, u)
    Deep(_, pr, m, sf) -> {
      let acc = reducel_finger(pr, acc, r_fn)
      let acc = reducel_node(m, acc, r_fn)
      reducel_finger(sf, acc, r_fn)
    }
  }
}

fn reducel_finger(finger: Finger(u), acc: v, r_fn: fn(v, u) -> v) -> v {
  case finger {
    One(u) -> r_fn(acc, u)
    Two(u, v) -> acc |> r_fn(u) |> r_fn(v)
    Three(u, v, w) -> acc |> r_fn(u) |> r_fn(v) |> r_fn(w)
    Four(u, v, w, x) -> acc |> r_fn(u) |> r_fn(v) |> r_fn(w) |> r_fn(x)
  }
}

fn reducel_node(node: FingerTree(Node(u)), acc: v, r_fn: fn(v, u) -> v) -> v {
  use acc, node <- reducer(node, acc)
  case node {
    Node1(u) -> r_fn(acc, u)
    Node2(u, v) -> acc |> r_fn(u) |> r_fn(v)
    Node3(u, v, w) -> acc |> r_fn(u) |> r_fn(v) |> r_fn(w)
  }
}

pub fn from_list(l: List(e)) {
  do_from_list(l, Empty)
}

fn do_from_list(l: List(e), tree: FingerTree(e)) {
  case tree, l {
    _, [] -> tree
    Empty, [a, b, c, d, e, f, g, h, i, j, k, ..rest] ->
      do_from_list(
        rest,
        Deep(11, Four(a, b, c, d), Single(Node3(e, f, g)), Four(h, i, j, k)),
      )
    Empty, [a, b, c, d, e, f, g, h, i, j] ->
      Deep(10, Four(a, b, c, d), Single(Node2(e, f)), Four(g, h, i, j))
    Empty, [a, b, c, d, e, f, g, h, i] ->
      Deep(9, Four(a, b, c, d), Single(Node1(e)), Four(f, g, h, i))
    Empty, [a, b, c, d, e, f, g, h] ->
      Deep(8, Four(a, b, c, d), Empty, Four(e, f, g, h))
    Empty, [a, b, c, d, e, f, g] ->
      Deep(7, Four(a, b, c, d), Empty, Three(e, f, g))
    Empty, [a, b, c, d, e, f] -> Deep(6, Four(a, b, c, d), Empty, Two(e, f))
    Empty, [a, b, c, d, e] -> Deep(5, Three(a, b, c), Empty, Two(d, e))
    Empty, [a, b, c, d] -> Deep(4, Two(a, b), Empty, Two(c, d))
    Empty, [a, b, c] -> Deep(3, Two(a, b), Empty, One(c))
    Empty, [a, b] -> Deep(2, One(a), Empty, One(b))
    Empty, [a] -> Single(a)

    Single(a), [b, c, d, e, f, g, h, ..rest] ->
      do_from_list(rest, Deep(8, Four(a, b, c, d), Empty, Four(e, f, g, h)))
    Single(a), [b, c, d, e, f, g] ->
      Deep(7, Four(a, b, c, d), Empty, Three(e, f, g))
    Single(a), [b, c, d, e, f] -> Deep(6, Four(a, b, c, d), Empty, Two(e, f))
    Single(a), [b, c, d, e] -> Deep(5, Three(a, b, c), Empty, Two(d, e))
    Single(a), [b, c, d] -> Deep(4, Two(a, b), Empty, Two(c, d))
    Single(a), [b, c] -> Deep(3, Two(a, b), Empty, One(c))
    Single(a), [b] -> Deep(2, One(a), Empty, One(b))

    Deep(s, pr, m, Four(a, b, c, d)), [e, f, g, ..rest] ->
      do_from_list(
        rest,
        Deep(s + 3, pr, m |> push(Node3(a, b, c)), Four(d, e, f, g)),
      )
    Deep(s, pr, m, Four(a, b, c, d)), [e, f] ->
      Deep(s + 2, pr, m |> push(Node2(a, b)), Four(c, d, e, f))
    Deep(s, pr, m, Four(a, b, c, d)), [e] ->
      Deep(s + 1, pr, m |> push(Node1(a)), Four(b, c, d, e))
    Deep(s, pr, m, sf), [e, f, g, h, ..rest] ->
      do_from_list(
        rest,
        Deep(s + 4, pr, m |> push(sf |> to_node), Four(e, f, g, h)),
      )
    Deep(s, pr, m, sf), [e, f, g] ->
      Deep(s + 3, pr, m |> push(sf |> to_node), Three(e, f, g))
    Deep(s, pr, m, sf), [e, f] ->
      Deep(s + 2, pr, m |> push(sf |> to_node), Two(e, f))
    Deep(s, pr, m, sf), [e] -> Deep(s + 1, pr, m |> push(sf |> to_node), One(e))
  }
}

fn to_node(digits: Finger(u)) {
  case digits {
    One(u) -> Node1(u)
    Two(u, v) -> Node2(u, v)
    Three(u, v, w) -> Node3(u, v, w)
    _ -> panic as "Somehow this broke?"
  }
}

pub fn to_list(tree: FingerTree(e)) {
  reducer(tree, [], fn(h, xs) { [xs, ..h] })
}

pub fn shift(tree: FingerTree(e)) -> Result(#(e, FingerTree(e)), Nil) {
  case tree {
    Empty -> Error(Nil)
    Single(e) -> Ok(#(e, Empty))
    Deep(s, pr, m, sf) -> {
      // a is the first element in the tree
      case shift_finger(pr) {
        #(popped_a, Some(new_pr)) -> Ok(#(popped_a, Deep(s - 1, new_pr, m, sf)))
        #(popped_a, None) -> {
          // the first element is now in the middle of the tree
          // the next element is the first element in the tree

          // pop the first node out of the tree
          case shift_node_tree(m) {
            Ok(#(Node3(a, b, c), rest_nodes)) ->
              Ok(#(popped_a, Deep(s - 1, Three(a, b, c), rest_nodes, sf)))
            Ok(#(Node2(a, b), rest_nodes)) ->
              Ok(#(popped_a, Deep(s - 1, Two(a, b), rest_nodes, sf)))
            Ok(#(Node1(a), rest_nodes)) ->
              Ok(#(popped_a, Deep(s - 1, One(a), rest_nodes, sf)))
            Error(Nil) -> {
              // the tree in the middle is empty
              case shift_finger(sf) {
                #(new_a, Some(new_sf)) ->
                  Ok(#(popped_a, Deep(s - 1, One(new_a), Empty, new_sf)))
                #(new_a, None) -> Ok(#(popped_a, Single(new_a)))
              }
            }
          }
        }
      }
    }
  }
}

fn shift_node_tree(nodes: FingerTree(Node(u))) {
  shift(nodes)
}

fn shift_finger(finger: Finger(u)) {
  case finger {
    One(u) -> #(u, None)
    Two(u, v) -> #(u, Some(One(v)))
    Three(u, v, w) -> #(u, Some(Two(v, w)))
    Four(u, v, w, x) -> #(u, Some(Three(v, w, x)))
  }
}

pub fn pop(tree: FingerTree(e)) -> Result(#(e, FingerTree(e)), Nil) {
  case tree {
    Empty -> Error(Nil)
    Single(e) -> Ok(#(e, Empty))
    Deep(s, pr, m, sf) -> {
      // a is the first element in the tree
      case pop_finger(sf) {
        #(popped_a, Some(new_sf)) -> Ok(#(popped_a, Deep(s - 1, pr, m, new_sf)))
        #(popped_a, None) -> {
          // the last element is now in the middle of the tree
          // the next element is the last element in the tree 

          // pop the first node out of the tree
          case pop_node_tree(m) {
            Ok(#(Node3(a, b, c), rest_nodes)) ->
              Ok(#(popped_a, Deep(s - 1, pr, rest_nodes, Three(a, b, c))))
            Ok(#(Node2(a, b), rest_nodes)) ->
              Ok(#(popped_a, Deep(s - 1, pr, rest_nodes, Two(a, b))))
            Ok(#(Node1(a), rest_nodes)) ->
              Ok(#(popped_a, Deep(s - 1, pr, rest_nodes, One(a))))
            Error(Nil) -> {
              // the tree itself is now empty, and the next element must be in the suffix
              case pop_finger(pr) {
                #(new_a, Some(new_pr)) ->
                  Ok(#(popped_a, Deep(s - 1, new_pr, Empty, One(new_a))))
                #(new_a, None) -> Ok(#(popped_a, Single(new_a)))
              }
            }
          }
        }
      }
    }
  }
}

fn pop_node_tree(nodes: FingerTree(Node(u))) {
  pop(nodes)
}

fn pop_finger(finger: Finger(u)) {
  case finger {
    One(u) -> #(u, None)
    Two(u, v) -> #(v, Some(One(u)))
    Three(u, v, w) -> #(w, Some(Two(u, v)))
    Four(u, v, w, x) -> #(x, Some(Three(u, v, w)))
  }
}

pub fn filter(tree: FingerTree(e), f: fn(e) -> Bool) -> FingerTree(e) {
  reducel(tree, Empty, fn(acc, e) {
    case f(e) {
      True -> acc |> push(e)
      False -> acc
    }
  })
}

pub fn new() {
  Empty
}

pub fn reverse(tree: FingerTree(e)) -> FingerTree(e) {
  reducel(tree, Empty, unshift)
}

pub fn drop(tree: FingerTree(e), n: Int) -> #(FingerTree(e), FingerTree(e)) {
  do_drop(tree, n, Empty)
}

fn do_drop(tree: FingerTree(e), n: Int, acc: FingerTree(e)) {
  case shift(tree), n {
    Ok(#(a, rest)), 0 -> #(acc |> push(a), rest)
    Ok(#(a, rest)), _ -> do_drop(rest, n - 1, acc |> push(a))
    Error(Nil), _ -> #(acc, tree)
  }
}

pub fn get(tree: FingerTree(u), get_idx: Int) {
  case
    reducel(tree, #(None, 0), fn(i, n) -> #(Option(u), Int) {
      case i, n {
        #(None, idx), n if idx == get_idx -> #(Some(n), idx + 1)
        #(a, n), _ -> #(a, n + 1)
      }
    })
  {
    #(Some(u), _) -> Ok(u)
    _ -> Error("Index out of bounds")
  }
}

pub const empty = Empty

pub fn size(tree: FingerTree(e)) {
  case tree {
    Empty -> 0
    Single(_) -> 1
    Deep(s, _, _, _) -> s
  }
}

pub fn try_reducel(
  tree: FingerTree(u),
  acc: v,
  l_fn: fn(v, u) -> Result(v, w),
) -> Result(v, w) {
  case tree {
    Empty -> Ok(acc)
    Single(u) -> l_fn(acc, u)
    Deep(_, pr, m, sf) -> {
      use acc <- result.try(try_reducel_finger(pr, acc, l_fn))
      use acc <- result.try(try_reducel_node(m, acc, l_fn))
      try_reducel_finger(sf, acc, l_fn)
    }
  }
}

fn try_reducel_finger(
  finger: Finger(u),
  acc: v,
  l_fn: fn(v, u) -> Result(v, w),
) -> Result(v, w) {
  case finger {
    One(u) -> l_fn(acc, u)
    Two(u, v) -> {
      use acc <- result.try(l_fn(acc, u))
      l_fn(acc, v)
    }
    Three(u, v, w) -> {
      use acc <- result.try(l_fn(acc, u))
      use acc <- result.try(l_fn(acc, v))
      l_fn(acc, w)
    }
    Four(u, v, w, x) -> {
      use acc <- result.try(l_fn(acc, u))
      use acc <- result.try(l_fn(acc, v))
      use acc <- result.try(l_fn(acc, w))
      l_fn(acc, x)
    }
  }
}

fn try_reducel_node(
  node: FingerTree(Node(u)),
  acc: v,
  l_fn: fn(v, u) -> Result(v, w),
) -> Result(v, w) {
  use acc, node <- try_reducel(node, acc)
  case node {
    Node1(u) -> l_fn(acc, u)
    Node2(u, v) -> {
      use acc <- result.try(l_fn(acc, u))
      l_fn(acc, v)
    }
    Node3(u, v, w) -> {
      use acc <- result.try(l_fn(acc, u))
      use acc <- result.try(l_fn(acc, v))
      l_fn(acc, w)
    }
  }
}

pub fn try_map(
  tree: FingerTree(u),
  map_fn: fn(u) -> Result(v, w),
) -> Result(FingerTree(v), w) {
  case tree {
    Empty -> Ok(Empty)
    Single(u) -> {
      use u <- result.map(map_fn(u))
      Single(u)
    }
    Deep(s, pr, m, sf) -> {
      use pr <- result.try(try_map_finger(pr, map_fn))
      use m <- result.try(try_map_node(m, map_fn))
      use sf <- result.map(try_map_finger(sf, map_fn))
      Deep(s, pr, m, sf)
    }
  }
}

fn try_map_finger(
  finger: Finger(u),
  map_fn: fn(u) -> Result(v, w),
) -> Result(Finger(v), w) {
  case finger {
    One(u) -> {
      use u <- result.map(map_fn(u))
      One(u)
    }
    Two(u, v) -> {
      use u <- result.try(map_fn(u))
      use v <- result.map(map_fn(v))
      Two(u, v)
    }
    Three(u, v, w) -> {
      use u <- result.try(map_fn(u))
      use v <- result.try(map_fn(v))
      use w <- result.map(map_fn(w))
      Three(u, v, w)
    }
    Four(u, v, w, x) -> {
      use u <- result.try(map_fn(u))
      use v <- result.try(map_fn(v))
      use w <- result.try(map_fn(w))
      use x <- result.map(map_fn(x))
      Four(u, v, w, x)
    }
  }
}

fn try_map_node(
  node_tree: FingerTree(Node(u)),
  map_fn: fn(u) -> Result(v, w),
) -> Result(FingerTree(Node(v)), w) {
  use node <- try_map(node_tree)
  case node {
    Node1(u) -> {
      use u <- result.map(map_fn(u))
      Node1(u)
    }
    Node2(u, v) -> {
      use u <- result.try(map_fn(u))
      use v <- result.map(map_fn(v))
      Node2(u, v)
    }
    Node3(u, v, w) -> {
      use u <- result.try(map_fn(u))
      use v <- result.try(map_fn(v))
      use w <- result.map(map_fn(w))
      Node3(u, v, w)
    }
  }
}

pub fn append(tree1: FingerTree(u), tree2: FingerTree(u)) -> FingerTree(u) {
  case tree1, tree2 {
    Empty, tree2 -> tree2
    Single(u), tree2 -> tree2 |> unshift(u)
    tree1, Empty -> tree1
    tree1, Single(u) -> tree1 |> push(u)
    tree1, tree2 -> reducel(tree2, tree1, push)
  }
}

pub fn prepend(tree1: FingerTree(u), tree2: FingerTree(u)) -> FingerTree(u) {
  append(tree2, tree1)
}

pub fn reducel_index(tree: FingerTree(u), acc: v, f: fn(v, u, Int) -> v) {
  let #(acc, _) = do_reducel_index(tree, acc, 0, f)
  acc
}

fn do_reducel_index(
  tree: FingerTree(u),
  acc: v,
  index: Int,
  f: fn(v, u, Int) -> v,
) {
  case tree {
    Empty -> #(acc, index)
    Single(u) -> #(f(acc, u, index), index + 1)
    Deep(_, pr, m, sf) -> {
      let #(acc, index) = do_reducel_index_finger(pr, acc, index, f)
      let #(acc, index) = do_reducel_index_node_tree(m, acc, index, f)
      let #(acc, index) = do_reducel_index_finger(sf, acc, index, f)
      #(acc, index)
    }
  }
}

fn do_reducel_index_finger(
  finger: Finger(u),
  acc: v,
  index: Int,
  f: fn(v, u, Int) -> v,
) {
  case finger {
    One(u) -> #(f(acc, u, index), index + 1)
    Two(u, v) -> {
      let acc = f(acc, u, index)
      #(f(acc, v, index), index + 1)
    }
    Three(u, v, w) -> {
      let acc = f(acc, u, index)
      let acc = f(acc, v, index + 1)
      #(f(acc, w, index + 2), index + 3)
    }
    Four(u, v, w, x) -> {
      let acc = f(acc, u, index)
      let acc = f(acc, v, index + 1)
      let acc = f(acc, w, index + 2)
      #(f(acc, x, index + 3), index + 4)
    }
  }
}

fn do_reducel_index_node_tree(
  node_tree: FingerTree(Node(u)),
  acc: v,
  index: Int,
  f: fn(v, u, Int) -> v,
) -> #(v, Int) {
  use #(acc, index), node <- reducel(node_tree, #(acc, index))
  case node {
    Node1(u) -> #(f(acc, u, index), index + 1)
    Node2(u, v) -> {
      let acc = f(acc, u, index)
      #(f(acc, v, index + 1), index + 2)
    }
    Node3(u, v, w) -> {
      let acc = f(acc, u, index)
      let acc = f(acc, v, index + 1)
      #(f(acc, w, index + 2), index + 3)
    }
  }
}

pub fn map_index(tree: FingerTree(u), f: fn(u, Int) -> v) -> FingerTree(v) {
  use tree, item, index <- reducel_index(tree, Empty)
  tree |> push(f(item, index))
}

pub fn map(tree: FingerTree(u), f: fn(u) -> v) -> FingerTree(v) {
  use tree, a <- reducel(tree, Empty)
  tree |> push(f(a))
}

pub fn set(tree: FingerTree(u), target_index: Int, target_item: u) {
  case tree |> size {
    n if n > target_index -> Error(Nil)
    _ ->
      Ok({
        use u, index <- map_index(tree)
        case target_index == index {
          True -> target_item
          False -> u
        }
      })
  }
}

pub fn take(tree: FingerTree(u), count: Int) {
  do_take(tree, Empty, count)
}

fn do_take(tree: FingerTree(u), acc: FingerTree(u), count: Int) {
  case tree, count {
    _, 0 -> Ok(#(acc, tree))
    Empty, _ -> Error(Nil)
    tree, count ->
      case shift(tree) {
        Ok(#(u, tree)) -> do_take(tree, acc |> push(u), count - 1)
        Error(_) -> Error(Nil)
      }
  }
}

pub fn peekl(tree: FingerTree(u)) -> Result(u, Nil) {
  case tree {
    Empty -> Error(Nil)
    Single(u) -> Ok(u)
    Deep(_, One(u), _, _) -> Ok(u)
    Deep(_, Two(u, _), _, _) -> Ok(u)
    Deep(_, Three(u, _, _), _, _) -> Ok(u)
    Deep(_, Four(u, _, _, _), _, _) -> Ok(u)
  }
}

pub fn peekr(tree: FingerTree(u)) -> Result(u, Nil) {
  case tree {
    Empty -> Error(Nil)
    Single(u) -> Ok(u)
    Deep(_, _, _, One(u)) -> Ok(u)
    Deep(_, _, _, Two(_, u)) -> Ok(u)
    Deep(_, _, _, Three(_, _, u)) -> Ok(u)
    Deep(_, _, _, Four(_, _, _, u)) -> Ok(u)
  }
}
