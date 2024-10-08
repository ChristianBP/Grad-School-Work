(* CS6335: Assignment 5

   Name: Christian Parker
   Email: cxp220034@utdallas.edu

 *)

Require Import List.
Print Forall.
Print In.

Theorem Forall_forall:
  forall {A:Type} P (l:list A),
    Forall P l <-> (forall x, In x l -> P x).
Proof.
  (* 1. Complete the proof. *)
  split.
  all: intros.
  all: induction l.
  - contradiction. (* x can't be in nil *)
  - inversion H; subst. simpl in H0.
    destruct H0.
    + rewrite H0 in H3. assumption.
    + apply IHl in H4; assumption.
  - apply Forall_nil.
  - apply Forall_cons.
    + apply H. simpl. now left.
    + apply IHl. intros. apply H. simpl. now right.
Qed.

Theorem Forall_app:
  forall {A:Type} P (l1 l2:list A),
    Forall P (l1++l2) <-> Forall P l1 /\ Forall P l2.
Proof.
  (* 2. Complete the proof. *)
  split; intros; induction l1; induction l2.
  all: try easy.
  - split.
    + now rewrite app_nil_r in H.
    + apply Forall_nil.
  - split.
    all: inversion H; subst.
    + apply Forall_cons. assumption. apply IHl1 in H3. now destruct H3.
    + apply IHl1 in H3. now destruct H3.
  - rewrite app_nil_r. now destruct H.
  - inversion H; subst. inversion H0; subst. simpl.
    apply Forall_cons. assumption. apply IHl1. split; assumption.
Qed.

Theorem Forall_map:
  forall {A B:Type} P (f:A->B) l,
    Forall (fun x => P (f x)) l <-> Forall P (map f l).
Proof.
  (* 3. Complete the proof. *)
  split.
  - induction l.
    + intros; simpl. apply Forall_nil.
    + intros. simpl. apply Forall_cons. inversion H; subst. assumption. inversion H; subst. apply IHl. assumption.
  - induction l.
    + intros. apply Forall_nil.
    + intros. apply Forall_cons. inversion H; subst. assumption. inversion H; subst. apply IHl. assumption.
Qed.

Theorem Forall_noadd:
  forall {A:Type} P f (l:list A),
    (forall x, In x (f l) -> In x l) -> Forall P l -> Forall P (f l).
Proof.
  (* 4. Complete the proof. *)
  intros.
  induction l.
  - apply Forall_forall. intros. apply H in H1. simpl in H1. contradiction.
  - inversion H0; subst. apply Forall_forall. intros. apply H in H1. simpl in H1. destruct H1. now rewrite <- H1.
    
Qed.

Corollary Forall_rev:
  forall {A:Type} P (l:list A), Forall P (rev l) <-> Forall P l.
Proof.
  (* 5. Complete the proof. *)
Qed.
