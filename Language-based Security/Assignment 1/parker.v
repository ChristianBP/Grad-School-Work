(* CS6335: Assignment 1

   Name: Christian Parker
   Email: cxp220034@utdallas.edu

 *)

Require Import Bool.

(* 2. Define "rexp" here. *)
Inductive rexp : Type :=
  | Empty
  | Epsilon
  | Sym (s:bool)
  | Plus (r1 r2:rexp)
  | Cat (r1 r2:rexp)
  | Star (r1:rexp).

(* 3. Define "myrexp" here. *)
Definition myrexp : rexp :=
  Cat (Star Empty) (Plus (Plus (Sym(false)) (Sym(true))) Epsilon).

(* 4. Define "matches_nil" here. *)
Fixpoint matches_nil (r:rexp) : bool :=
  match r with
  | Epsilon => true
  | Star r1 => true
  | Plus r1 r2 => orb (matches_nil r1) (matches_nil r2)
  | Cat r1 r2 => andb (matches_nil r1) (matches_nil r2)
  | _ => false
  end.

Example myrexp_matches_nil:
  matches_nil myrexp = true.
Proof.
  (* 5. Complete the proof. *)
  simpl. reflexivity.
Qed.

Lemma matches_nil_cat2:
  forall r, matches_nil (Cat r r) = matches_nil r.
Proof.
  (* 6. Complete the proof. *)
  intros. simpl. destruct matches_nil.
  reflexivity.
  reflexivity.
Qed.

(* 7a. Explain why first "bool_eq" attempt fails. *)
(* Definition bool_eq (b1 b2:bool) := if b1=b2 then true else false. *)
(*
  The term "b1 = b2" has type "Prop" which is not a (co-)inductive type.

  The operator "=" returns a "Prop" which maps on to the mathematical
  concept of equality. However, "if" only receives boolean values and therefore
  expects logical equality to have been evaluated by the time it receives a parameter.
  This discrepancy triggers the error.
*)

(* 7b. Explain why second "bool_eq" attempt fails. *)
(* Definition bool_eq (b1 b2:bool) := 
  match b1 with
    | b2 => true
    | _ => false
  end. *)
(*
  Pattern "_" is redundant in this clause.

  "match with" expects expressions that contain values or variables.
  It does not expect to receive function arguments and so it considers
  b2 to be a variable. Since this b2 is a variable, it matches any value of b1.
  So, in this case, b2 and _ are accept the same values. Thus, the _ clause is redundant.
*)

(* 7c. Implement a correct "bool_eq" here. *)
Definition bool_eq (b1 b2:bool) :=
  match b1, b2 with
  | true, true => true
  | false, false => true
  | _, _ => false
  end.

(* 7d. Prove that "bool_eq" is correct. *)
Example bool_eq_is_correct:
  forall b, bool_eq b b = true.
Proof.
  intro. destruct b.
  simpl. reflexivity.
  simpl. reflexivity.
Qed.

(* 8. Define "rem" here. *)
Fixpoint rem (r:rexp) (o:bool) : rexp :=
  match r with
  | Sym s => if bool_eq s o then Epsilon else Empty
  | Empty => Empty
  | Epsilon => Empty
  | Plus r1 r2 => Plus (rem r1 o) (rem r2 o)
  | Cat r1 r2 => 
    match matches_nil r1 with
    | true => rem r2 o
    | false => Cat (rem r1 o) r2
    end
  | Star r1 => Cat (rem r1 o) (Star r1)
  end.

Compute rem myrexp false.

(* rem (false (false + true)∗) false *)
Compute rem (Cat (Sym false) (Star (Plus (Sym false) (Sym true)))) false.

(* rem (false (false + true)∗) true *)
Compute rem (Cat (Sym false) (Star (Plus (Sym false) (Sym true)))) true.

(* rem (false∗ + true∗) true *)
Compute rem (Plus (Star (Sym false)) (Star (Sym true))) true.

(* rem ((false∗)(true∗)) true *)
Compute rem (Cat (Star (Sym false)) (Star (Sym true))) true.
