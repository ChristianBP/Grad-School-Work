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
        if matches_nil r1
          then Plus (Cat (rem eq r1 o) r2) (rem eq r2 o)
          else Cat (rem eq r1 o) r2
  end.

Fixpoint matches {A:Set} (eq:eqdec A) (r:rexp A) (s:list A) : bool :=
  match s with
    | nil => matches_nil r
    | h :: t => matches eq (rem eq r h) t
  end.

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
  split; intros; induction r; try solve [inversion H | constructor]; simpl in *.
  - apply orb_prop in H. destruct H.
    + apply MPlus1, IHr1. assumption.
    + apply MPlus2, IHr2. assumption.
  - apply andb_prop in H. destruct H. apply (MCat _ _ nil nil).
    + apply IHr1. assumption.
    + apply IHr2. assumption.
  - inversion H; subst.
    + rewrite IHr1. reflexivity. assumption.
    + rewrite IHr2. apply orb_true_r. assumption.
  - inversion H; subst. apply app_eq_nil in H3. destruct H3; subst. rewrite IHr1, IHr2 by assumption. reflexivity.
Qed.

Theorem Matches_rem:
  forall {A:Set} (eq:eqdec A) a r s,
    Matches r (a::s) <-> Matches (rem eq r a) s.
Proof.
  split.
  - revert s; induction r; intros; inversion H; subst; simpl.
    + destruct (eq a a). constructor. contradiction.
    + apply MPlus1, IHr1, M.
    + apply MPlus2, IHr2, M.
    + destruct s1.
      -- simpl in H3. subst s2. apply Matches_nil in M1. rewrite M1. apply MPlus2, IHr2, M2.
      -- inversion H3; subst. destruct (matches_nil r1). apply MPlus1.
        all: apply MCat; try apply IHr1; assumption.
    + apply MCat. apply IHr. assumption. assumption.
  - revert s; induction r; intros; simpl in *.
    + inversion H.
    + inversion H.
    + destruct (eq s a); inversion H; subst. constructor.
    + inversion H; subst.
      -- apply MPlus1, IHr1, M.
      -- apply MPlus2, IHr2, M.
    + destruct (matches_nil r1) eqn:MN; inversion H; subst.
      -- inversion M; subst. apply (MCat _ _ (a :: s1) s2). apply IHr1. assumption. assumption.
      -- apply (MCat _ _ nil (a :: s)). apply Matches_nil. assumption. apply IHr2. assumption.
      -- apply (MCat _ _ (a::s1) s2). apply IHr1. assumption. assumption.
    + inversion H; subst. apply MStar. apply IHr. assumption. assumption.
Qed.

Theorem Matches_matches:
  forall {A:Set} (eq:eqdec A) s r,
    matches eq r s = true <-> Matches r s.
Proof.
  (* 3. Complete the proof. *)
  induction s.
    apply Matches_nil.
    split; intro.
      eapply Matches_rem. apply IHs. eassumption.
      eapply Matches_rem in H. apply IHs. eassumption.
Qed.