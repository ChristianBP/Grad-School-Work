Require Import Program.Equality. (* for the dependent induction tactic *)
Require Import Arith.
Require Import String.
Open Scope string_scope.

(***
 *** Syntax of SIMPL
 ***)

Section Simpl.

(* Program variables are represented abstractly as an arbitrary Set for which there is an
   equality decision procedure. *)

Inductive lambda :=
  | Var (v:string)
  | Lambda (v:string) (e:lambda)
  | Apply (e1:lambda) (e2:lambda).

Notation "'λ' v '.' e" := (Lambda v e) (at level 100, e at next level, no associativity).


(***
 *** Large-step Operational Semantics of SIMPL
 ***)

Fixpoint replace (e:lambda) (v:string) (e1:lambda) : lambda :=
  match e with
  | Var x => if x =? v then e1 else Var x
  | λ x. e2 => if x =? v then λ x. e2 else λ x. (replace e2 v e1)
  | Apply e2 e3 => Apply (replace e2 v e1) (replace e3 v e1)
  end.

Inductive lconv: lambda -> lambda -> Prop :=
  | LO_Ident v e:
    lconv (λ v. e) (λ v. e)

  | LO_Apply e1 v e e2 e'
    (H1: lconv e1 (λ v. e)) (H2: lconv (replace e v e2) e'):
          lconv (Apply e1 e2) e'.

Notation "e ⇓ e'" := (lconv e e') (at level 70, e' at next level, no associativity).


(***
 *** Small-step Operational Semantics of SIMPL
 ***)

Inductive step_lambda : lambda -> lambda -> Prop :=
| SO_Replace v e1 e2:
    step_lambda (Apply (λ v. e1) e2) (replace e1 v e2)

| SO_Apply e1 e2 e1'
       (SL: step_lambda e1 e1'):
    step_lambda (Apply e1 e2) (Apply e1' e2).

Notation "x ->₁ x'" := (step_lambda x x') (at level 70, x' at next level, no associativity).

(* Define the reflexive, transitive closure of a small-step relation: *)
Inductive rtclosure {A:Type} (R: A -> A -> Prop): nat -> A -> A -> Prop :=
  | RTC_Refl (x:A): rtclosure R O x x (* i=0 steps *)
  | RTC_Step (x1 x2 x':A) (i:nat)     (* i>0 steps *)
             (Hfst: R x1 x2) (Hrst: rtclosure R i x2 x'):
             rtclosure R (S i) x1 x'.

Notation "x ->{ n  } x'" := (rtclosure step_lambda n x x') (at level 70, x' at next level, no associativity).




(***
 *** Proof of Semantic Equivalence for SIMPL
 ***
 *** Theorem: The following three statements are equivalent:
 ***   (1) <c,s> ⇓ s'
 ***   (2) <c,s> ->* <Skip,s'>
 ***)

(* All the 1-step rules that reduce a sub-expression can be extended to n-step rules:
         x ->₁x'                   x ->n x'
     ----------------   ====>   ----------------
     op(x) ->₁op(x')            op(x) ->n op(x')

   All the proofs are pretty much the same, so I condense them into a macro below.
   (An even better way is to use "evaluation contexts", but we haven't covered that
   yet in class.)
 *)

Definition nstep_subexp {A B:Type}
    (R1: (A) -> (A) -> Prop)
    (R2: (B) -> (B) -> Prop) (op: B -> A) : Prop :=
  forall i x x', rtclosure R2 i (x) (x') -> rtclosure R1 i (op x) (op x').

Ltac prove_reduce_subexp T :=
  let i:=fresh in let H:=fresh in let IH:=fresh in
  intros; intro i; (induction i as [|? IH]; intros ? ? ? ? H; inversion H as [|? (?,?)]; subst);
  [ apply RTC_Refl
  | eapply RTC_Step;
    [ eapply T; eassumption
    | apply IH; eassumption ] ].

(* Lemma nstep_seq1: forall e2, nstep_subexp step_lambda step_lambda (fun e1 => Apply e1 e2).
Proof. prove_reduce_subexp SO_Apply. Qed. *)

(* Lemma nstep_assign: forall e v, nstep_subexp step_lambda step_lambda (replace e v).
Proof. prove_reduce_subexp SO_Replace. Qed.
*)

(* Prove that rtclosure really is transitively closed. *)
Lemma rtc_split:
  forall (A:Type) R i j (x1 x' x'':A),
  rtclosure R i x1 x' -> rtclosure R j x' x'' -> rtclosure R (i+j) x1 x''.
Proof.
  induction i; intros.
    inversion H; subst. assumption.
    inversion H; subst. simpl. eapply RTC_Step.
      exact Hfst.
      eapply IHi. exact Hrst. exact H0.
Qed.


(* Part I: "LO_imp_SO" (1) => (2)
 *   large-step convergence implies small-step convergence *)

Theorem cmd_LO_imp_SO:
  forall e e', (e) ⇓ e' -> exists i, (e) ->{i} (e').
Proof.
  intros. dependent induction H; subst.

  (* Ident *)
  exists 0. apply RTC_Refl.

  (* Seq *)
  edestruct IHlconv2 as [i IH1]. induction e. simpl in IH1. eassumption. reflexivity.
  edestruct IHconv_cmd2 as [j IH2]. eassumption. reflexivity.
  exists (i+(S j)). eapply rtc_split.
    apply nstep_seq1. exact IH1.
    eapply RTC_Step. apply SO_Seq_Skip. exact IH2.
Qed.

End Simpl.
