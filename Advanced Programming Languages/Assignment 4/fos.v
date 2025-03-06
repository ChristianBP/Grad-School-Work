Require Import List.
Import ListNotations.
Require Import String.
Require Import Datatypes.
Require Import Lia.
Open Scope list_scope.
Open Scope string.

(* Question 1 *)
(* 1.a *)
Inductive fos :=
  | STrue | SFalse
  | SOr (s1 s2 : fos)
  | SNot (s : fos)
  | SVar (x : string)
  | SForall (x : string) (s : fos)
  | SExists (x : string) (s : fos).

(* 1.b *)
Definition mysentence :=
  SForall "x" (SOr (SForall "x" (SVar "x")) (SNot (SVar "x"))).

(* 1.c *)
Fixpoint freevars s : (list string) :=
  match s with
  | STrue | SFalse => []
  | SOr s1 s2 => (freevars s1) ++ (freevars s2)
  | SNot s1 => freevars s1
  | SVar x => x :: []
  | SForall x s1 => List.remove string_dec x (freevars s1)
  | SExists x s1 => List.remove string_dec x (freevars s1)
  end.

Definition eqdec A := forall (x y:A), {x=y}+{x<>y}.
Definition update {A B} (eq:eqdec A) f x y z : B :=
  if eq x z then y else f z.

Fixpoint istrue tfv s : bool :=
  match s with
  | STrue => true
  | SFalse => false
  | SOr s1 s2 => orb (istrue tfv s1) (istrue tfv s2)
  | SNot s1 => negb (istrue tfv s1)
  | SVar x => tfv x
  | SForall x s1 => andb (istrue (update string_dec tfv x false) s1) (istrue (update string_dec tfv x true) s1)
  | SExists x s1 => orb (istrue (update string_dec tfv x false) s1) (istrue (update string_dec tfv x true) s1)
  end.

Definition istautology (s : fos) : bool :=
  andb (match (freevars s) with [] => true | _ => false end) (istrue (fun x => false) s).

Definition print x := fold_left append x "".

(* 1.e *)
Fixpoint string_of_fos s : string :=
  match s with
  | STrue => "T"
  | SFalse => "F"
  | SOr s1 s2 => (string_of_fos s1) ++ "\\/" ++ (string_of_fos s2)
  | SNot s1 => "~" ++ (string_of_fos s1)
  | SVar x => x
  | SForall x s1 => "A" ++ x ++ ".(" ++ (string_of_fos s1) ++ ")"
  | SExists x s1 => "E" ++ x ++ ".(" ++ (string_of_fos s1) ++ ")"
  end.

(* Question 3 *)
Fixpoint compose_n {A} f n x : A :=
  match n with
  | 0 => x
  | S n => compose_n f (n - 1) (f x)
  end.

(* Question 4 *)
Definition selectall {A} (f : nat -> bool) l :=
fst (fold_left (fun (acc : (list A) * nat) h =>
  let (lst, index) := acc in 
  ((if f index then h :: lst else lst), index + 1)) l ([], 1)).

Fixpoint eval tfv (s:fos) : Prop :=
  match s with
  | STrue => True
  | SFalse => False
  | SVar v => tfv v = true
  | SOr s1 s2 => eval tfv s1 \/ eval tfv s2
  | SNot s1 => ~eval tfv s1
  | SForall v s1 => forall b, eval (update string_dec tfv v b) s1
  | SExists v s1 => exists b, eval (update string_dec tfv v b) s1
  end.

Theorem istrue_correctness:
  forall s tfv, istrue tfv s = true <-> eval tfv s.
Proof.
  induction s; split; intro; simpl in *; try easy.
  - apply Bool.orb_true_iff in H. destruct H.
    + apply IHs1 in H. left. assumption.
    + apply IHs2 in H. right. assumption.
  - destruct H.
    + apply IHs1 in H. rewrite H. lia.
    + apply IHs2 in H. rewrite H. lia.
  - unfold "~". intro. apply IHs in H0. rewrite H0 in H. discriminate.
  - unfold "~" in H. apply Bool.eq_true_not_negb. unfold "<>". intro. apply H.
    apply IHs. assumption.
  - apply Bool.andb_true_iff in H. destruct H. intro. destruct b; apply IHs; assumption.
  - apply Bool.andb_true_iff. split; apply IHs; easy.
  - apply Bool.orb_true_iff in H. destruct H.
    + exists false. apply IHs. eassumption.
    + exists true. apply IHs. assumption.
  - destruct H as [b H]. destruct b.
    + apply Bool.orb_true_iff. right. apply IHs. assumption.
    + apply Bool.orb_true_iff. left. apply IHs. assumption.
Qed.

Theorem closure:
  forall s tfv tfv', freevars s = nil -> eval tfv s -> eval tfv' s.
Proof.
  intros. induction s; simpl in *; try easy.
  apply app_eq_nil in H. destruct H.
  destruct H0.
    left. apply IHs1; assumption.
    right. apply IHs2; assumption.
  apply IHs in H.
    unfold "~" in *. intro. apply H0.
Qed.

Theorem correctness:
  forall s, freevars s = nil -> istautology s = true <-> (forall tfv, eval tfv s).
Proof.
  intros.
Qed.