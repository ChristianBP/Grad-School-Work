Require Import String.
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


(***
 *** Large-step Operational Semantics of Lambda Calc
 ***)

Inductive lconv: lambda -> lambda -> Prop :=
  | L1 v e:
    lconv (λ v. e) (λ v. e)

  | L2 e1 v e e2 e'
    (H1: lconv e1 (λ v. e)) (H2: lconv (replace e v e2) e'):
          lconv (Apply e1 e2) e'.

Notation "e ⇓ e'" := (lconv e e') (at level 70, e' at next level, no associativity).


(***
 *** Small-step Operational Semantics of Lambda Calc
 ***)

Inductive step_lambda : lambda -> lambda -> Prop :=
| S1 v e1 e2:
    step_lambda (Apply (λ v. e1) e2) (replace e1 v e2)

| S2 e1 e2 e1'
       (SL: step_lambda e1 e1'):
    step_lambda (Apply e1 e2) (Apply e1' e2).

Notation "x ->₁ x'" := (step_lambda x x') (at level 70, x' at next level, no associativity).


(***
 *** Proof of Semantic Equivalence for Lambda Calc
 ***
 *** Theorem: The following statements are equivalent:
 ***   (1) e ⇓ e'' and e ->₁ e'
 ***   (2) e' ⇓ e''
 ***)

(* Part I: "LO_S1_imp_LO'" (1) => (2)
 *   large-steps still converge after a small-step *)

Theorem lambda_LO_S1_imp_LO':
  forall e e', (e ->₁ e') -> (forall e'', e ⇓ e'' -> e' ⇓ e'').
Proof.
  intros e e' H_DS. induction H_DS; intros. all: inversion_clear H.

  (* S1 *)
  inversion H1; subst. assumption.

  (* S2 e1 v e e2 e'*)
  eapply L2.
    eapply IHH_DS. eassumption.
    eassumption.
Qed.
