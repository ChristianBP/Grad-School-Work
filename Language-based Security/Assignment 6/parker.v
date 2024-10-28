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
        Plus (Cat (rem eq r1 o) r2) (if matches_nil r1 then Plus (Cat r1 (rem eq r2 o)) (rem eq r2 o) else Empty)
  end.

Fixpoint matches {A:Set} (eq:eqdec A) (r:rexp A) (s:list A) : bool :=
  match s with
    | nil => matches_nil r
    | h :: t => matches eq (rem eq r h) t
  end.

Lemma matches_nil_cat2:
  forall A (r:rexp A) , matches_nil (Cat r r) = matches_nil r.
Proof.
  intros. simpl. destruct matches_nil; reflexivity.
Qed.

Theorem rem_cat_nil_sym:
  forall (A:Set) (eq:eqdec A) (r:rexp A) (o:A), matches_nil r = true -> matches_nil (rem eq (Cat r (Sym o)) o) = true.
Proof.
  intros. simpl. rewrite H.
  destruct eq; simpl.
    rewrite H. rewrite orb_true_r. reflexivity.
    contradiction.
Qed.

Theorem matches_plus_or:
  forall (A:Set) (l:list A) (r1 r2:rexp A) (eq:eqdec A), matches eq (Plus r1 r2) l = matches eq r1 l || matches eq r2 l.
Proof.
  induction l.
    - (* l = nil *)
      reflexivity.
    - (* l = a :: l *)
      intros. simpl. rewrite IHl. reflexivity.
Qed.

Theorem matches_app:
  forall (A:Set) (s1 s2:list A) (r1 r2:rexp A) (eq:eqdec A), matches eq r1 s1 = true -> matches eq r2 s2 = true ->
    matches eq (Cat r1 r2) (s1++s2) = true.
Proof.
  intros A s1 s2; induction s1; intros.
    - induction s2; simpl in *; rewrite H.
      + assumption.
      + repeat rewrite matches_plus_or. rewrite H0. repeat rewrite orb_true_r. reflexivity.
    - destruct (matches_nil r1); simpl in *.
      + repeat rewrite matches_plus_or. apply IHs1 with (r2:=r2) in H.
        -- rewrite H. repeat rewrite orb_true_l. reflexivity.
        -- assumption.
      + apply IHs1 with (r2:=r2) in H.
        -- rewrite matches_plus_or, H, orb_true_l. reflexivity.
        -- assumption.
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
  split; intros; induction r; try solve [inversion H | constructor]; simpl; simpl in H.
  - destruct (matches_nil r1).
    + apply MPlus1. apply IHr1. reflexivity.
    + apply MPlus2. apply IHr2. simpl in H. assumption.
  - rewrite <- app_nil_l. apply MCat.
    + apply IHr1. destruct (matches_nil r2).
      -- rewrite andb_true_r in H. assumption.
      -- rewrite andb_false_r in H. discriminate.
    + apply IHr2. destruct (matches_nil r1).
      -- simpl in H. assumption.
      -- simpl in H. discriminate.
  - apply orb_true_iff. inversion H; subst.
    + left. apply IHr1. assumption.
    + right. apply IHr2. assumption.
  - inversion H; subst. apply app_eq_nil in H3; destruct H3. apply andb_true_iff.
    split.
    + apply IHr1. rewrite H0 in M1. assumption.
    + apply IHr2. rewrite H1 in M2. assumption.
Qed.

Theorem Matches_rem:
  forall {A:Set} (eq:eqdec A) a r s,
    Matches r (a::s) <-> Matches (rem eq r a) s.
Proof.
  induction r; split; intros; inversion H; subst; simpl in *; try destruct eq; subst; try discriminate.
    apply MEpsilon.
    contradiction.
    apply MSym.
    apply MPlus1. apply IHr1. assumption.
    apply MPlus2. apply IHr2. assumption.
    apply MPlus1. apply IHr1. assumption.
    apply MPlus2. apply IHr2. assumption.
    destruct s1; simpl in *; subst.
      apply Matches_nil in M1. rewrite M1. repeat apply MPlus2. apply IHr2. assumption.
      apply MPlus1. inversion H3; subst. apply MCat.
        apply IHr1. assumption.
        assumption.
    clear H. inversion M; subst. rewrite app_comm_cons. apply MCat.
      apply IHr1. assumption.
      assumption.
    clear H. rewrite <- app_nil_l. apply MCat.
      apply Matches_nil. case_eq (matches_nil r1); intros.
        reflexivity.
        rewrite H in M. inversion M.
        admit.
    all: apply MCat || apply MStar; try apply IHr; assumption.
Admitted.

Theorem Matches_matches:
  forall {A:Set} (eq:eqdec A) s r,
    matches eq r s = true <-> Matches r s.
Proof.
  (* 3. Complete the proof. *)
  induction s; split; intros; simpl in *.
    apply Matches_nil. assumption.
    apply Matches_nil. assumption.
    eapply Matches_rem. apply IHs. exact H.
    eapply Matches_rem in H. apply IHs. exact H.
Qed.