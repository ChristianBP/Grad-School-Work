(* CS6371: Assignment 1

   Name: Christian Parker
   Email: cxp220034@utdallas.edu

 *)

(* Question 1 *)
print_endline ("\nQuestion 1");;

(* 1.a *)
type fos =
  | True | False
  | Not of fos
  | Or of fos * fos
  | Var of string
  | Forall of string * fos
  | Exists of string * fos
;;

(* 1.b *)
let mysentence =
  Forall ("x", Or (Forall ("x", Var "x"), Not (Var "x")));;

mysentence;;

(* 1.c *)
print_endline ("1.c)");;

List.exists ((String.equal) "a") ["a"; "b"; "c"; "d"]

let rec freevars s =
  match s with
  | True | False -> []
  | Not s1 -> freevars s1
  | Or (s1, s2) -> freevars s1 @ freevars s2
  | Var x -> [x]
  | Forall (x, s1) -> List.filter (fun a -> not (String.equal a x)) (freevars s1)
  | Exists (x, s1) -> List.filter (fun a -> not (String.equal a x)) (freevars s1)
;;

List.iter (fun x -> Printf.printf "%s " x) (freevars mysentence);
print_endline ("");;

let freevars_test =
  Or (Forall ("x", Var "x"), Var "x");;

List.iter (fun x -> Printf.printf "%s " x) (freevars freevars_test);
print_endline ("");;

(* 1.d *)
print_endline ("\n1.d)");;

let removevar l v =
  List.filter (fun a -> not (String.equal a v)) l

let rec istrue tfv s =
  match s with
  | True -> true
  | False -> false
  | Not s1 -> not (istrue tfv s1)
  | Or (s1, s2) -> (istrue tfv s1 || istrue tfv s2)
  | Var x -> List.exists ((String.equal) x) tfv
  | Forall (x, s1) -> (istrue (removevar tfv x) s1) && (istrue (x :: (removevar tfv x)) s1)
  | Exists (x, s1) -> (istrue (removevar tfv x) s1) || (istrue (x :: (removevar tfv x)) s1)
;;

let tautology s =
  not (List.is_empty (freevars s)) && istrue (freevars s) s;;

Printf.printf "%B" (tautology mysentence);
print_endline ("");;

Printf.printf "%B" (tautology freevars_test);
print_endline ("");;

let mysentence2 =
  Forall ("x", Or (Or (True, False), Not (Var "x")));;

Printf.printf "%s %B" "tautology mysentence2: " (tautology mysentence2);
print_endline ("");;

(* 1.e *)
print_endline ("\n1.e)");;

let rec string_of_fos s =
  match s with
  | True -> "T"
  | False -> "F"
  | Not s1 -> "~" ^ (string_of_fos s1)
  | Or (s1, s2) -> "(" ^ (string_of_fos s1) ^ ")\\/(" ^ (string_of_fos s2) ^ ")"
  | Var x -> x
  | Forall (x, s1) -> "A" ^ x ^ ".(" ^ (string_of_fos s1) ^ ")"
  | Exists (x, s1) -> "E" ^ x ^ ".(" ^ (string_of_fos s1) ^ ")"
;;

Printf.printf "%s %s" "string_of_fos mysentence: " (string_of_fos mysentence);
print_endline ("");;

Printf.printf "%s %s" "string_of_fos mysentence2: " (string_of_fos mysentence2);
print_endline ("");;

(* Question 2 *)
print_endline ("\nQuestion 2");;

let update f x y z =
  if x = z then y else f z;;

let f s = s ^ "abc";;
let g = (update f "X" "Y");;

print_endline (g "A");
print_endline (g "M");
print_endline (g "X");;

(* Question 3 *)
print_endline ("\nQuestion 3");;

let rec compose_n f n m =
  match n with
  | 0 -> m
  | n' -> compose_n f (n'-1) (f m)

let g = (compose_n f 2);;

print_endline (g "XYZ");;
print_endline (g "ABC");;

let f n = n + 2;;
let g = (compose_n f 5);;

print_int (g 0);;
print_endline "";;
print_int (g 5);;
print_endline "";;

(* Question 4 *)
print_endline ("\nQuestion 4");;

let selectall f =
  List.fold_left (fun (acc, count) h -> (acc @ (if f count then [h] else []), count + 1)) ([], 1);;

List.iter (fun x -> Printf.printf "%s " x) (fst (selectall (fun n -> n mod 2 = 0) ["a"; "b"; "c"; "d"]));
print_endline ("");;
