Require Import Program.Equality.
Require Import ZArith.
Require Import String.
Require Import List.
Open Scope Z.
Open Scope string_scope.

Inductive lambda :=
  | Var (v:string)
  | Lambda (v:string) (e:lambda)
  | Apply (e1:lambda) (e2:lambda).

Notation "'λ' v '.' e" := (Lambda v e) (at level 100, e at next level, no associativity).

Fixpoint replace (e:lambda) (v:string) (e1:lambda) : lambda :=
  match e with
  | Var x => if x =? v then e1 else Var x
  | λ x. e2 => if x =? v then λ x. e2 else λ x. (replace e2 v e1)
  | Apply e2 e3 => Apply (replace e2 v e1) (replace e3 v e1)
  end.

Definition λtrue := λ "x" . λ "y" . Var "x".
Definition λfalse := λ "x" . λ "y" . Var "y".
Definition λnot := λ "b" . Apply (Apply (Var "b") λfalse) λtrue.
Definition λand := λ"a". λ"b". Apply (Apply (Var "a") (Var "b")) λfalse.
Definition λor := λ"a". λ"b". Apply (Apply (Var "a") λtrue) (Var "b").
Definition λpair := λ"x". λ"y". λ"b". Apply (Apply (Var "b") (Var "x")) (Var "y").
Definition π1 := λ"x" . Apply (Var "x") λtrue.
Definition π2 := (λ"x" . Apply (Var "x") λfalse).
Definition λ0N := (λ"x". Var "x").
Definition succN := (Apply λpair λfalse).
Definition predN := π2.
Definition iszeroN := π1.
Definition λY := (λ"f". Apply (λ"x". Apply (Var "f") (Apply (Var "x") (Var "x")))(λ"x". Apply (Var "f") (Apply (Var "x") (Var "x")))).
Definition addN := (Apply λY (λ"f". λ"m". λ"n". ((Apply (Apply (Apply iszeroN (Var "m")) (Var "n")) (Apply (Apply (Var "f") (Apply predN (Var "m"))) (Apply succN (Var "n"))))))).
Definition subN := (Apply λY (λ"f". λ"m". λ"n". ((Apply (Apply (Apply iszeroN (Var "n")) (Var "m")) (Apply (Apply (Var "f") (Apply predN (Var "m"))) (Apply predN (Var "n"))))))).
Definition multN := (Apply λY (λ"f". λ"m". λ"n". (Apply (Apply (Apply iszeroN (Var "m")) λ0N) (Apply (Apply addN (Apply (Apply (Var "f") (Apply predN (Var "m"))) (Var "n"))) (Var "n"))))).

Inductive lconv: lambda -> lambda -> Prop :=
  | Rule1 v e:
    lconv (λ v. e) (λ v. e)

  | Rule2 e1 v e e2 e'
    (H1: lconv e1 (λ v. e)) (H2: lconv (replace e v e2) e'):
          lconv (Apply e1 e2) e'.

Notation "<< e >> ⇓ e'" := (lconv e e') (at level 90, e' at next level, no associativity).

Definition isempty :=
  Apply (λ"l". Apply λnot (Apply π1 (Var "l"))).

Definition Nil :=
  (Apply (Apply λpair λfalse) (λ"x". Var "x")).

Definition Cons (h t:lambda) : lambda :=
  (Apply (Apply λpair λtrue) (Apply (Apply λpair h) t)).

Definition nonempty_list :=
  Cons λ0N Nil.

(* Assignment #6, Question #2a: *)
Theorem isempty_Nil:
  << isempty Nil >> ⇓ λtrue.
Proof.
  unfold isempty.
  repeat eapply Rule1 || eapply Rule2 || simpl.
Qed.

Theorem nonempty_list_isempty:
  << isempty nonempty_list >> ⇓ λfalse.
Proof.
  unfold isempty.
  repeat eapply Rule1 || eapply Rule2 || simpl.
Qed.

(* Assignment #6, Question #2b: *)
Definition head :=
  Apply (λ"l". Apply π1 (Apply π2 (Var "l"))).

Definition tail :=
  Apply (λ"l". Apply π2 (Apply π2 (Var "l"))).

Definition some_list :=
  Cons λfalse (Cons λtrue (Cons λ0N Nil)).

Fixpoint no_free_vars (vars: list string) e : bool :=
  match e with
  | Var x => existsb (fun a => a =? x) vars
  | λ x. e1 => no_free_vars (x :: vars) e1
  | Apply e1 e2 => no_free_vars vars e1 || no_free_vars vars e2
  end.

Theorem no_free_replace:
  forall v e l,
    no_free_vars nil l = true ->
    replace l v e = l.
Proof.
  intros.
  induction l; simpl in *.
    discriminate.
    destruct (v0 =? v) eqn:H0.
      reflexivity.
      apply eqb_neq in H0.

Admitted.

(* Theorem head_works:
  forall h t,
  no_free_vars nil h = true ->
  (* << Apply λnot (isempty (Cons h t)) >> ⇓ λtrue -> *)
  << head (Cons h t) >> ⇓ h.
Proof.
  intros.
  unfold head.
  - eapply Rule2. eapply Rule1. simpl.
    change (λ "x" . (λ "y" . Var "y")) with λfalse.
    change (λ "x" . (λ "y" . Var "x")) with λtrue.
    eapply Rule2. eapply Rule1. simpl.
    change (λ "x" . (λ "y" . Var "x")) with λtrue.
    eapply Rule2. eapply Rule2. eapply Rule1. simpl. eapply Rule2.
    unfold Cons. eapply Rule2. eapply Rule2. eapply Rule1. simpl.
    eapply Rule1. simpl. eapply Rule1. simpl.
    eapply Rule2. eapply Rule2. eapply Rule1. simpl.
    eapply Rule1. simpl. eapply Rule2. eapply Rule2. eapply Rule1. simpl.
    eapply Rule1. simpl. eapply Rule1. simpl. unfold λtrue.
    repeat eapply Rule1 || eapply Rule2 || simpl.
    change (λ "x" . (λ "y" . Var "y")) with λfalse.
    change (λ "x" . (λ "y" . Var "x")) with λtrue.
    eapply no_free_replace in H.
Qed. *)

Theorem tail_works:
  << tail some_list >> ⇓ (Cons λtrue (Cons λ0N Nil)).
Proof.
  unfold tail. unfold λtrue. unfold λ0N. unfold Nil. unfold λpair.
  repeat eapply Rule1 || eapply Rule2 || simpl.
Qed.