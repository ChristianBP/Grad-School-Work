(* CS6335: Assignment 6

   Name: Christian Parker
   Email: cxp220034@utdallas.edu

 *)

Require Import Bool.
Require Import List.

(*** INSERT ASSIGNMENT 4 SOLUTION HERE. ***)
Definition eqdec (A:Set) := forall (a1 a2:A), {a1=a2}+{a1<>a2}.

Inductive rexp (A:Set) : Type :=
  | Empty
  | Epsilon
  | Sym (s : A)
  | Plus (r1 r2 : rexp A)
  | Cat (r1 r2 : rexp A)
  | Star (r1 : rexp A).

Arguments Empty {A}.
Arguments Epsilon {A}.
Arguments Sym {A}.
Arguments Plus {A}.
Arguments Cat {A}.
Arguments Star {A}.

Fixpoint matches_nil {A:Set} (r:rexp A) : bool :=
  match r with
  | Epsilon => true
  | Star r1 => true
  | Plus r1 r2 => orb (matches_nil r1) (matches_nil r2)
  | Cat r1 r2 => andb (matches_nil r1) (matches_nil r2)
  | _ => false
  end.

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

Theorem rem_cat_nil_sym:
  forall (A:Set) (eq:eqdec A) (r:rexp A) (o:A), matches_nil r = true -> matches_nil (rem eq (Cat r (Sym o)) o) = true.
Proof.
  intros. simpl. rewrite H.
  destruct eq; simpl.
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
  intros A s1 s2; induction s1; intros; induction s2; simpl in H; simpl.
    1,2: rewrite H.
    - easy.
    - rewrite matches_plus_or. simpl in H0. rewrite H0. now rewrite orb_true_r.
    - destruct matches_nil.
      rewrite matches_plus_or. now rewrite IHs1. now rewrite IHs1.
    - destruct matches_nil.
      rewrite matches_plus_or. now rewrite IHs1. now rewrite IHs1.
Qed.
(*** END ASSIGNMENT 4 SOLUTION. ***)

Inductive Matches {A:Set} : rexp A -> list A -> Prop :=
| MEpsilon: Matches Epsilon nil
| MSym (a:A): Matches (Sym a) (a::nil)
| MPlus1 r1 r2 s (M: Matches r1 s): Matches (Plus r1 r2) s
| MPlus2 r1 r2 s (M: Matches r2 s): Matches (Plus r1 r2) s
| MCat r1 r2 s1 s2 (M1: Matches r1 s1) (M2: Matches r2 s2):
    Matches (Cat r1 r2) (s1++s2)
| MStar0 r: Matches (Star r) nil
| MStar r (a:A) s1 s2 (M0: Matches r (a::s1)) (M: Matches (Star r) s2):
    Matches (Star r) (a::s1++s2).

Theorem Matches_nil:
  forall {A:Set} (r:rexp A), matches_nil r = true <-> Matches r nil.
Proof.
  (* 1. Complete the proof. *)
  split.
  all: induction r.
  all: intros; try easy.
  constructor.
Admitted.

Theorem Matches_rem:
  forall {A:Set} (eq:eqdec A) a r s,
    Matches r (a::s) <-> Matches (rem eq r a) s.
Proof.
  (* 2. Complete the proof. *)
  split; intros. inversion H. simpl.
  apply Matches_nil.
Admitted.

Theorem Matches_matches:
  forall {A:Set} (eq:eqdec A) s r,
    matches eq r s = true <-> Matches r s.
Proof.
  (* 3. Complete the proof. *)
  split; intros.
Qed.
