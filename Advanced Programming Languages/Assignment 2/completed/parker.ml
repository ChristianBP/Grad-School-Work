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

(* This is the main entrypoint of the code. You don't need to understand
 * how it works to complete the assignment, but here's a short explanation
 * for those interested:
 *  * The first 'let' statement reads the .sim file and invokes an external
 *    parser (defined in simplparser.mly) to convert the file into an icmd
 *    structure.
 *  * The next 'let' statement calls your init_store code to create a
 *    store s from the rest of the command-line arguments. The first
 *    command-line argument gets assigned to variable "arg0", the next to
 *    "arg1", etc.
 *  * The third 'let' statement calls your exec_cmd code to execute the icmd
 *    starting in the initial store.
 *  * If the SIMPL program terminates (and your code is correct) then s2 will
 *    eventually hold the final store that results from executing the
 *    program. We then print out the value of variable "ret" as the result
 *    of the computation.
 *)
let main () =
  (match (Array.to_list Sys.argv) with
    | [] -> raise (Sys_error "invalid argument list")
    | [_] -> raise (Failure "please specify a program to interpret")
    | _::prog::args ->
      let c = (Simplparser.parse_cmd Simpllexer.token 
                (Lexing.from_channel (open_in prog))) in
      let s = init_store (Array.to_list (Array.mapi
                (fun i a -> ("arg"^(string_of_int i),
                  (try int_of_string a
                    with Failure _ -> raise (Failure "args must be ints"))))
                (Array.of_list args))) in
      let s2 = exec_cmd s c in
        (print_string (match (try Some (s2 "ret") with Not_found -> None) with
                        | None -> "<no value returned>"
                        | Some n -> string_of_int n);
          print_newline ()));;

main ();;