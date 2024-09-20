(* CS6335: Assignment 4

   Name: Christian Parker
   Email: cxp220034@utdallas.edu

 *)

Require Import Bool.
Require Import List.

Definition eqdec (A:Set) := forall (a1 a2:A), {a1=a2}+{a1<>a2}.

(*** INSERT ASSIGNMENT 3 SOLUTION HERE AND MODIFY IT AS FOLLOWS: ***)
(* 1. Redefine rexp to be polymorphic. *)
Inductive rexp (A:Set) : Type :=
  | Empty
  | Epsilon
  | Sym (s : A)
  | Plus (r1 r2 : rexp A)
  | Cat (r1 r2 : rexp A)
  | Star (r1 : rexp A).

(* 2. Make type parameter A of rexp be implicit. *)
Arguments Empty {A}.
Arguments Epsilon {A}.
Arguments Sym {A}.
Arguments Plus {A}.
Arguments Cat {A}.
Arguments Star {A}.

Definition myrexp :=
  Cat (Star Empty) (Plus (Plus (Sym(true)) (Sym(false))) Epsilon).
Definition myrexp2 :=
  Cat (Star Empty) (Plus (Plus (Sym(4)) (Sym(12))) Epsilon).

(* 3. Reprove maches_nil and matches_nil_cat2 as necessary. *)
Fixpoint matches_nil {A:Set} (r:rexp A) : bool :=
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
  forall A (r:rexp A) , matches_nil (Cat r r) = matches_nil r.
Proof.
  simpl. intros. now destruct matches_nil.
Qed.

(* 4. Redefine rem and matches to use eqdec (defined above). *)
Fixpoint rem {A:Set} (eq:eqdec A) (r:rexp A) (o:A) : rexp A :=
  match r with
    | Sym s => if eq s o then Epsilon else Empty
    | Empty => Empty
    | Epsilon => Empty
    | Star r1 => Cat (rem eq r1 o) (Star r1)
    | Plus r1 r2 => Plus (rem eq r1 o) (rem eq r2 o)
    | Cat r1 r2 =>
      if matches_nil r1 then
        Plus (Cat (rem eq r1 o) r2) (rem eq r2 o)
      else
        Cat (rem eq r1 o) r2
  end.

Fixpoint matches {A:Set} (eq:eqdec A) (r:rexp A) (s:list A) : bool :=
  match s with
    | nil => matches_nil r
    | h :: t => matches eq (rem eq r h) t
  end.

(* 5. Reprove rem_cat_nil_sym, matches_plus_or, and matches_app. *)
Theorem rem_cat_nil_sym:
  forall (A:Set) (eq:eqdec A) (r:rexp A) (o:A), matches_nil r = true -> matches_nil (rem eq (Cat r (Sym o)) o) = true.
Proof.
  intros. simpl. rewrite H.
  destruct eq.
    all: simpl.
    now rewrite orb_true_r.
    destruct n. reflexivity.
Qed.

Theorem matches_plus_or:
  forall (A:Set) (l:list A) (r1 r2:rexp A) (eq:eqdec A), matches eq (Plus r1 r2) l = matches eq r1 l || matches eq r2 l.
Proof.
  induction l.
    - (* l = nil *)
      easy.
    - (* l = a :: l *)
      intros. simpl. now rewrite IHl.
Qed.

Theorem matches_app:
  forall (A:Set) (s1 s2:list A) (r1 r2:rexp A) (eq:eqdec A), matches eq r1 s1 = true -> matches eq r2 s2 = true ->
    matches eq (Cat r1 r2) (s1++s2) = true.
Proof.
  intros A s1 s2.
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
