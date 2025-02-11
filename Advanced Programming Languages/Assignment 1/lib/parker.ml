(* CS6371: Assignment 1

   Name: Christian Parker
   Email: cxp220034@utdallas.edu

 *)

(* Question 1 *)
(* 1.a *)
type fos =
  | True | False
  | Or of fos * fos
  | Not of fos
  | Var of string
  | Forall of string * fos
  | Exists of string * fos
;;

(* 1.b *)
let mysentence =
  Forall ("x", Or (Forall ("x", Var "x"), Not (Var "x")));;

(* 1.c *)
let rec freevars s =
  match s with
  | True | False -> []
  | Or (s1, s2) -> freevars s1 @ freevars s2
  | Not s1 -> freevars s1
  | Var x -> [x]
  | Forall (x, s1) -> List.filter (fun a -> not (String.equal a x)) (freevars s1)
  | Exists (x, s1) -> List.filter (fun a -> not (String.equal a x)) (freevars s1)
;;

(* 1.d *)
let removevar l v =
  List.filter (fun a -> not (String.equal a v)) l

let rec istrue tfv s =
  match s with
  | True -> true
  | False -> false
  | Or (s1, s2) -> (istrue tfv s1 || istrue tfv s2)
  | Not s1 -> not (istrue tfv s1)
  | Var x -> List.exists ((String.equal) x) tfv
  | Forall (x, s1) -> (istrue (removevar tfv x) s1) && (istrue (x :: tfv) s1)
  | Exists (x, s1) -> (istrue (removevar tfv x) s1) || (istrue (x :: tfv) s1)
;;

let tautology s =
  List.is_empty (freevars s) && istrue [] s;;

(* 1.e *)
let rec string_of_fos s =
  match s with
  | True -> "T"
  | False -> "F"
  | Or (s1, s2) -> (string_of_fos s1) ^ "\\/" ^ (string_of_fos s2)
  | Not s1 -> "~" ^ (string_of_fos s1)
  | Var x -> x
  | Forall (x, s1) -> "A" ^ x ^ ".(" ^ (string_of_fos s1) ^ ")"
  | Exists (x, s1) -> "E" ^ x ^ ".(" ^ (string_of_fos s1) ^ ")"
;;

(* Question 2 *)
let update f x y z =
  if x = z then y else f z;;

(* Question 3 *)
let rec compose_n f n m =
  if n <= 0 then m else compose_n f (n-1) (f m);;

(* Question 4 *)
let selectall f l =
  fst (List.fold_left (fun (acc, index) h -> (acc @ (if f index then [h] else []), index + 1)) ([], 1) l);;