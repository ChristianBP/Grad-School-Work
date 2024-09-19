(* CS6335: Assignment 3

   Name: Christian Parker
   Email: cxp220034@utdallas.edu

 *)

Require Import Bool.
Require Import List.

(*** INSERT ASSIGNMENT 1 SOLUTION HERE. ***)
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

Lemma matches_nil_cat2:
  forall r, matches_nil (Cat r r) = matches_nil r.
Proof.
  (* 6. Complete the proof. *)
  intros. simpl. destruct matches_nil.
  reflexivity.
  reflexivity.
Qed.

(* 7c. Implement a correct "bool_eq" here. *)
Definition bool_eq (b1 b2:bool) :=
  match b1, b2 with
  | true, true => true
  | false, false => true
  | _, _ => false
  end.

Definition is_empty (r:rexp) :=
  match r with
    | Empty => true
    | _ => false
  end.

(* 8. Define "rem" here. *)
Fixpoint rem (r:rexp) (o:bool) : rexp :=
  match r with
    | Sym s => if bool_eq s o then Epsilon else Empty
    | Empty => Empty
    | Epsilon => Empty
    | Star r1 => Cat (rem r1 o) (Star r1)
    | Plus r1 r2 => Plus (rem r1 o) (rem r2 o)
    | Cat r1 r2 =>
      if matches_nil r1 then
        Plus (Cat (rem r1 o) r2) (rem r2 o)
      else
        Cat (rem r1 o) r2
  end.
(*** ASSIGNMENT 1 SOLUTION END. ***)

(* 1. Define "matches" here. *)
Fixpoint matches (r:rexp) (s:list bool) : bool :=
  match s with
    | nil => matches_nil r
    | h :: t => matches (rem r h) t
  end.

Theorem orb_true:
  forall b, b || true = true.
Proof.
  intros. induction b. reflexivity. reflexivity.
Qed.

Theorem rem_cat_nil_sym:
  forall b r, matches_nil r = true -> matches_nil (rem (Cat r (Sym b)) b) = true.
Proof.
  (* 2. Complete the proof. *)
  intros. simpl. rewrite H.
  induction b.
    - (* b = true *)
      simpl. rewrite orb_true. reflexivity.
    - (* b = false *)
      simpl. rewrite orb_true. reflexivity.
Qed.

Theorem matches_plus_or:
  forall s r1 r2, matches (Plus r1 r2) s = matches r1 s || matches r2 s.
Proof.
  (* 3. Complete the proof. *)
  intros s.
  induction s.
    - (* s = nil *)
      simpl. reflexivity.
    - (* s = a :: s *)
      simpl. intros. simpl. apply IHs.
Qed.

Print app_comm_cons.
(*
app_comm_cons =
fun (A : Type) (x y : list A) (a : A) => eq_refl
     : forall (A : Type) (x y : list A) (a : A), a :: x ++ y = (a :: x) ++ y
*)
Search (_ ++ nil).

Theorem matches_app:
  forall s1 s2 r1 r2, matches r1 s1 = true -> matches r2 s2 = true ->
    matches (Cat r1 r2) (s1++s2) = true.
Proof.
  (* 4. Complete the proof. *)
  intros s1 s2.
  induction s1.
    - induction s2.
      + intros. simpl. inversion H. rewrite H2. simpl. assumption.
      + intros. simpl. inversion H. rewrite H2. inversion H0.
        rewrite matches_plus_or; rewrite H3. rewrite orb_true_r. reflexivity.
    - induction s2.
      + intros. rewrite <- app_comm_cons. rewrite app_nil_r. rewrite app_nil_r in IHs1. simpl.
        destruct matches_nil.
          rewrite matches_plus_or. specialize IHs1 with (r1:=rem r1 a).
          rewrite IHs1.
            reflexivity.
            simpl in H. assumption.
            assumption.
          specialize IHs1 with (r1:=rem r1 a).
          apply IHs1. simpl in H. assumption. assumption.
      + intros. rewrite <- app_comm_cons. simpl. destruct matches_nil. rewrite matches_plus_or. rewrite IHs1.
        reflexivity.
        simpl in H. assumption. assumption.
        rewrite IHs1. reflexivity. simpl in H. assumption. assumption.
Qed.
