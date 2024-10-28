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
  split; intros; induction l.
  - inversion H0.
  - inversion H; subst. simpl in H0. destruct H0.
    + rewrite H0 in H3. assumption.
    + apply IHl in H4; assumption.
  - apply Forall_nil.
  - apply Forall_cons.
    + apply H, in_eq.
    + apply IHl. intros. apply H. simpl. right. assumption.
Qed.

Theorem Forall_app:
  forall {A:Type} P (l1 l2:list A),
    Forall P (l1++l2) <-> Forall P l1 /\ Forall P l2.
Proof.
  (* 2. Complete the proof. *)
  split; intros; induction l1; induction l2; simpl.
  - split; apply Forall_nil.
  - split. apply Forall_nil. simpl in H. assumption.
  - split; rewrite app_nil_r in H. assumption. apply Forall_nil.
  - split; inversion H; subst; apply IHl1 in H3. apply Forall_cons.
    all: destruct H3; assumption.
  - apply Forall_nil.
  - destruct H; assumption.
  - rewrite app_nil_r. destruct H. assumption.
  - inversion H; inversion H0; subst.
    apply Forall_cons; try apply IHl1; try split; assumption.
Qed.

Theorem Forall_map:
  forall {A B:Type} P (f:A->B) l,
    Forall (fun x => P (f x)) l <-> Forall P (map f l).
Proof.
  (* 3. Complete the proof. *)
  split; induction l; intros; simpl; constructor.
  all: inversion H; subst.
  all: try apply IHl; assumption.
Qed.

Theorem Forall_noadd:
  forall {A:Type} P f (l:list A),
    (forall x, In x (f l) -> In x l) -> Forall P l -> Forall P (f l).
Proof.
  (* 4. Complete the proof. *)
  intros. apply Forall_forall. intros. apply H in H1.
  eapply Forall_forall. exact H0. assumption.
Qed.

Corollary Forall_rev:
  forall {A:Type} P (l:list A), Forall P (rev l) <-> Forall P l.
Proof.
  (* 5. Complete the proof. *)
  split; intros; apply Forall_forall; intros.
  all: eapply Forall_forall.
  exact H. rewrite in_rev in H0. assumption.
  exact H. rewrite in_rev in H0. rewrite rev_involutive in H0. assumption.
Qed.
