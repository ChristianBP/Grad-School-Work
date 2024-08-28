(* CS6335: Assignment 1

   Name: Christian Parker
   Email: cxp220034@utdallas.edu

 *)

Require Import Bool.

(* 2. Define "rexp" here. *)
Inductive rexp : Type :=
  | Empty ()
  | Epsilon ("")
  | Sym (s : bool)
  | Plus (r1 | r2 : rexp)
  | Cat (r1 r2 : rexp)
  | Star (Star(r1) r2 : rexp).

(* 3. Define "myrexp" here. *)

(* 4. Define "matches_nil" here. *)

Example myrexp_matches_nil:
  matches_nil myrexp = true.
Proof.
  (* 5. Complete the proof. *)
Qed.

Lemma matches_nil_cat2:
  forall r, matches_nil (Cat r r) = matches_nil r.
Proof.
  (* 6. Complete the proof. *)
Qed.

(* 7a. Explain why first "bool_eq" attempt fails. *)

(* 7b. Explain why second "bool_eq" attempt fails. *)

(* 7c. Implement a correct "bool_eq" here. *)

(* 8. Define "rem" here. *)
