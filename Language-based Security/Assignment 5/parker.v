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
  split; intros; induction l; try easy.
  - inversion H; subst. simpl in H0. destruct H0.
    + now rewrite H0 in H3.
    + now apply IHl in H4.
  - apply Forall_cons.
    + apply H. apply in_eq.
    + apply IHl. intros. apply H. simpl. now right.
Qed.

Theorem Forall_app:
  forall {A:Type} P (l1 l2:list A),
    Forall P (l1++l2) <-> Forall P l1 /\ Forall P l2.
Proof.
  (* 2. Complete the proof. *)
  split; intros; induction l1; induction l2; try easy.
  - split; now rewrite app_nil_r in H.
  - split; inversion H; subst.
    all: apply IHl1 in H3.
    apply Forall_cons.
    all: now destruct H3.
  - rewrite app_nil_r. now destruct H.
  - inversion H; subst. inversion H0; subst. simpl.
    apply Forall_cons; apply IHl1 || idtac; easy.
Qed.

Theorem Forall_map:
  forall {A B:Type} P (f:A->B) l,
    Forall (fun x => P (f x)) l <-> Forall P (map f l).
Proof.
  (* 3. Complete the proof. *)
  split; induction l; intros; simpl; try easy.
  all: apply Forall_cons.
  all: inversion H; subst.
  all: easy || now apply IHl.
Qed.

Theorem Forall_noadd:
  forall {A:Type} P f (l:list A),
    (forall x, In x (f l) -> In x l) -> Forall P l -> Forall P (f l).
Proof.
  (* 4. Complete the proof. *)
  intros. apply Forall_forall. intros. apply H in H1.
  now apply Forall_forall with (x:=x) in H0.
Qed.

Corollary Forall_rev:
  forall {A:Type} P (l:list A), Forall P (rev l) <-> Forall P l.
Proof.
  (* 5. Complete the proof. *)
  split; intros; apply Forall_forall; intros.
  all: apply Forall_forall with (x:=x) in H.
  all: rewrite in_rev in H0.
  all: now try rewrite rev_involutive in H0.
Qed.
