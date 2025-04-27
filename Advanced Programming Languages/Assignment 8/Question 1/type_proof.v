Require Import String.
Require Import Bool.
Open Scope string_scope.

Inductive lambda_type :=
  | TypUnit
  | TypInt
  | TypBool
  | TypPair (t1 t2:lambda_type)
  | TypCond (t1 t2:lambda_type)
  | TypImpl (a B:lambda_type)
  | TypForall (a:string) (t:lambda_type)
  | TypVar (v:string).

Definition Void := TypForall "a" (TypVar "a").

Inductive lambda :=
  | Unit
  | Int (i:nat)
  | Bool (b:bool)
  | Pair (e1 e2:lambda)
  | In1 (t:lambda_type) (e:lambda)
  | In2 (t:lambda_type) (e:lambda)
  | Case (t:lambda_type) (e e1 e2:lambda)
  | Lambda (v:string) (t:lambda_type) (e:lambda)
  | BigLambda (a:string) (e:lambda)
  | Var (v:string)
  (* | Apply (e1:lambda) (e2:lambda). *).

(* Notation "'λ' v '.' e" := (Lambda v e) (at level 100, e at next level, no associativity). *)
Definition typctx := string -> lambda_type.

Definition init_typctx (l : list (string * lambda_type)) : typctx :=
  fun (x:string) => match List.find (fun v => fst v =? x) l with
  | Some (_, t) => t
  | None => Void
  end.

Definition update (tc:typctx) (v:string) i := (fun (x:string) => if x=?v then i else (tc x)).

(* Fixpoint replace (e:lambda) (v:string) (e1:lambda) : lambda :=
  match e with
  | Var x => if x =? v then e1 else Var x
  | Lambda x e2 => if x =? v then Lambda x e2 else Lambda x (replace e2 v e1)
  | Apply e2 e3 => Apply (replace e2 v e1) (replace e3 v e1)
  end. *)

Fixpoint matches e1 e2 :=
  match e1, e2 with
  | TypUnit, TypUnit => true
  | TypInt, TypInt => true
  | TypBool, TypBool => true
  | TypPair t1 t2, TypPair t3 t4 => matches t1 t3 && matches t2 t4
  | TypCond t1 t2, TypCond t3 t4 => matches t1 t3 && matches t2 t4
  | TypImpl a1 B1, TypImpl a2 B2 => matches a1 a2 && matches B1 B2
  | TypForall a1 t1, TypForall a2 t2 => String.eqb a1 a2 && matches t1 t2
  | TypVar v1, TypVar v2 => v1 =? v2
  | _, _ => false
  end.

Fixpoint derive_type (tc:typctx) (e:lambda) : lambda_type :=
  match e with
  | Unit => TypUnit
  | Int _ => TypInt
  | Bool _ => TypBool
  | Pair e1 e2 => TypPair (derive_type tc e1) (derive_type tc e2)
  | In1 (TypCond t1 t2) e =>
      if matches (derive_type tc e) t1
      then TypCond t1 t2
      else Void
  | In2 (TypCond t1 t2) e =>
      if matches (derive_type tc e) t2
      then TypCond t1 t2
      else Void
  | Case (TypCond t1 t2) e e1 e2 =>
      if matches (derive_type tc e) t1
      then (derive_type tc e1)
      else (
        if matches (derive_type tc e) t2
        then (derive_type tc e2)
        else Void)
  | Lambda v t e => TypImpl t (derive_type (update tc v t) e)
  | BigLambda a e => TypForall a (derive_type tc e)
  | Var v => tc v
  | _ => Void
  (* | Apply (e1:lambda) (e2:lambda) => TypInt *)
  end.

(* Theorem memchr_partial_correctness:
  forall s p c_in len mem t s' x'
         (ENTRY: startof t (x',s') = (Addr 1048576,s))
         (MDL: models arm8typctx s)
         (MEM: s V_MEM64 = Ⓜmem)
         (R0: s R_X0 = Ⓠp) (R1: s R_X1 = Ⓠ(c_in mod 2 ^ 8)) (R2: s R_X2 = Ⓠlen),
  satisfies_all memchr_lo_memchr_armv8 (memchr_invs mem p c_in len) memchr_exit ((x',s')::t). *)


Theorem question1:
  forall tc tcond
    (TC: tc = init_typctx nil)
    (TYPE_COND: tcond = TypCond
      (TypForall "a" (TypPair (TypVar "a") (TypVar "a")))
      (TypForall "a" (TypImpl (TypVar "a") TypUnit))),
  exists (e:lambda),
  derive_type tc e = tcond.
Proof.
  intros.
  exists (In2 tcond (BigLambda "a" (Lambda "x" (TypVar "a") Unit))).
  subst; simpl. constructor.
Qed.

Theorem question2:
  forall tc tcond
    (TC: tc = init_typctx nil)
    (TYPE_COND: tcond = (TypCond
      (TypPair (TypVar "a") (TypVar "a"))
      (TypImpl (TypVar "a") TypUnit))),
  exists (e:lambda),
  derive_type tc e = TypForall "a" tcond.
Proof.
  intros.
  exists (BigLambda "a" (In2 tcond
    (Lambda "x" (TypVar "a") Unit))).
  subst; simpl. constructor.
Qed.

Theorem question4:
  forall tc
    (TC: tc = init_typctx nil),
  exists (e:lambda),
  derive_type tc e = (TypForall "B" (TypImpl Void (TypVar "B"))).
Proof.
  intros.
  exists (BigLambda "B" (Lambda "x" Void (Case
    (TypCond (TypVar "B") TypUnit)
    Unit Unit
    (Case
      (TypCond (TypVar "B") TypInt)
      (Int 3) (Int 3)
      (Case
        (TypCond (TypVar "B") Void)
        (Bool true) (Bool true)
        (Var "x")))))).
  subst.
  destruct (BigLambda "B") eqn:H0.
    simpl.