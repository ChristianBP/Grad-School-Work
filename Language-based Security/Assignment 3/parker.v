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
  simpl. intros. now destruct matches_nil.
Qed.

(* 7c. Implement a correct "bool_eq" here. *)
Definition bool_eq (b1 b2:bool) :=
  match b1, b2 with
  | true, true => true
  | false, false => true
  | _, _ => false
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

Lemma orb_true:
  forall b, b || true = true.
Proof.
  now induction b.
Qed.

Theorem rem_cat_nil_sym:
  forall b r, matches_nil r = true -> matches_nil (rem (Cat r (Sym b)) b) = true.
Proof.
  (* 2. Complete the proof. *)
  intros. simpl. rewrite H.
  induction b.
    all: simpl.
    all: now rewrite orb_true.
Qed.

Theorem matches_plus_or:
  forall s r1 r2, matches (Plus r1 r2) s = matches r1 s || matches r2 s.
Proof.
  (* 3. Complete the proof. *)
  induction s.
    - (* s = nil *)
      easy.
    - (* s = a :: s *)
      intros. simpl. now rewrite IHs.
Qed.

Theorem matches_app:
  forall s1 s2 r1 r2, matches r1 s1 = true -> matches r2 s2 = true ->
    matches (Cat r1 r2) (s1++s2) = true.
Proof.
  (* 4. Complete the proof. *)
  intros s1 s2.
  induction s1.
    all: intros.
    - (* s1 = nil *)
      induction s2.
        all: simpl.
        all: simpl in H.
        all: rewrite H.
      + (* s2 = nil *)
        assumption.
      + (* s2 = a :: s2 *)
        rewrite matches_plus_or.
        simpl in H0. rewrite H0. now rewrite orb_true_r.
    - (* s1 = a :: s1 *)
      induction s2.
        all: simpl.
        all: destruct matches_nil.
        all: try rewrite matches_plus_or.
        all: now rewrite IHs1.
Qed.
