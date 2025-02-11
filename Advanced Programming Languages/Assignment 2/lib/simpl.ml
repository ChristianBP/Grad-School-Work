(* CS6371: Assignment 2

   Name: Christian Parker
   Email: cxp220034@utdallas.edu

*)

open Simpltypes

(* The 'store' models the machine's memory as a mapping from
 * variable names to integers. *)
type store = varname -> int

let init_store (l : (varname*int) list) : store =
  (* YOUR CODE GOES HERE
   * Replace the following line with code that takes a list of
   * (variable,integer) pairs and returns a store that maps each
   * variable to each corresponding integer. If your store function
   * is applied to a variable not in the list, it may return any
   * integer or it may raise an exception. *)
  (fun v -> List.assoc v l);;

let rec eval_arith (s:store) (a:iarith) : int =
  (* YOUR CODE GOES HERE
   * Replace the following line with code that evaluates iarith
   * expression 'a' in memory state 's' and returns an integer.
   * The type 'iarith' is defined in simpltypes.ml. *)
  match a with
  | Const (x) -> x
  | Var (x) -> s x
  | Plus (x, y) -> (eval_arith s x) + (eval_arith s y)
  | Minus (x, y) -> (eval_arith s x) - (eval_arith s y)
  | Times (x, y) -> (eval_arith s x) * (eval_arith s y)
  ;;

let rec eval_bool (s:store) (b:ibool) : bool =
  (* YOUR CODE GOES HERE
   * Replace the following line with code that evaluates ibool
   * expression 'b' in memory state 's' and returns a bool.
   * The type 'ibool' is defined in simpltypes.ml. *)
   match b with
  | True -> true
  | False -> false
  | Leq (x, y) -> (eval_arith s x) <= (eval_arith s y)
  | Conj (x, y) -> (eval_bool s x) && (eval_bool s y)
  | Disj (x, y) -> (eval_bool s x) || (eval_bool s y)
  | Neg (x) -> not (eval_bool s x)
  ;;

let update f x y z =
  if x = z then y else f z;;

let rec exec_cmd (s:store) (c:icmd) : store =
  (* YOUR CODE GOES HERE
   * Replace the following line with code that executes icmd
   * 'c' in memory state 's' and returns the new memory state
   * that results. Type 'icmd' is defined in simpltypes.ml. *)
  match c with
  | Skip -> s
  | Seq (x, y) -> exec_cmd (exec_cmd s x) y
  | Assign (x, y) -> update s x (eval_arith s y)
  | Cond (b, x, y) -> exec_cmd s (if (eval_bool s b) then x else y)
  | While (b, x) -> if (eval_bool s b) then exec_cmd (exec_cmd s x) (While (b, x)) else s
  ;;

