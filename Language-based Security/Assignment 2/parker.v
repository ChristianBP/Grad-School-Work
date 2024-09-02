(* CS6335: Assignment 2

   Name: Christian Parker
   Email: cxp220034@utdallas.edu

 *)

(* 1. Define "bin" here. *)
Inductive bin : Type :=
  | Z : bin
  | B0 (b : bin)
  | B1 (b : bin).

(* 2. Define "incr" here. *)
Fixpoint incr (b:bin) : bin :=
  match b with
  | Z => B1 Z
  | B0 b' => B1 b'
  | B1 b' => B0 (incr b')
  end.

(* 3. Define "bin_to_nat" here. *)
Fixpoint bin_to_nat (b:bin) : nat :=
  match b with
  | Z => O
  | B0 b' => 2 * (bin_to_nat b')
  | B1 b' => 1 + 2 * (bin_to_nat b')
  end.

Lemma plus_n_Sm:
  forall n m : nat, n + (S m) = S (n + m).
Proof.
  intros n m. induction n.
    - (* n = 0 *)
      reflexivity.
    - (* n = S n *)
      simpl. rewrite IHn. reflexivity.
Qed.

Theorem bin_to_nat_pres_incr:
  forall b, bin_to_nat (incr b) = S (bin_to_nat b).
Proof.
  (* 4. Complete the proof. *)
  induction b.
    - (* b = Z *)
      reflexivity.
    - (* b = B0 b *)
      simpl. reflexivity.
    - (* b = B1 b *)
      simpl. rewrite IHb. simpl. rewrite plus_n_Sm. reflexivity.
Qed.

(* 5. Define "nat_to_bin" here. *)
Fixpoint nat_to_bin (n:nat) : bin :=
  match n with
  | O => Z
  | S n' => incr (nat_to_bin n')
  end.

Theorem bin_nat_inv:
  forall n, bin_to_nat (nat_to_bin n) = n.
Proof.
  (* 6. Complete the proof. *)
  induction n.
  - (* n = 0 *)
    reflexivity.
  - (* n = S n *)
    simpl. rewrite bin_to_nat_pres_incr. rewrite IHn. reflexivity.
Qed.

(* 7. Explain why (nat_to_bin (bin_to_nat b)) = b is not a true theorem. *)
(*
  The problem is that we can add any number of B0's before a Z and the bin
  will always still be equal to Z. So if we convert a bin like
  B0 B0 B0 Z to a nat, then we get 0, and when convert it back, we get just Z,
  which currently does not get recognized as equal to B0 B0 B0 Z.
*)

Definition double_bin (b:bin) : bin :=
  match b with
    | Z => Z
    | b => B0 b
  end.

(* 8. Define "normalize" here. *)
Fixpoint normalize (b:bin) : bin :=
  match b with
    | Z => Z
    | B0 b' => double_bin (normalize b')
    | B1 b' => incr (double_bin (normalize b'))
  end.

Example normalize_0: normalize(B0 (B0 (B0 Z))) = Z.
  reflexivity.
Qed.

Example normalize_1: normalize(B1 (B0 (B0 (B0 Z)))) = B1 Z.
  reflexivity.
Qed.

Theorem add_0_r : forall n:nat, n + 0 = n.
Proof.
  intros n. induction n as [| n' IHn'].
  - (* n = 0 *) reflexivity.
  - (* n = S n' *) simpl. rewrite IHn'. reflexivity.
Qed.

Lemma double_incr_bin:
  forall b, double_bin (incr b) = incr (incr (double_bin b)).
Proof.
  induction b.
    - reflexivity.
    - reflexivity.
    - reflexivity.
Qed.

Lemma two_times_nat_to_double_bin:
  forall n, nat_to_bin (n + n) = double_bin (nat_to_bin n).
Proof.
  induction n.
    - (* n = 0 *)
      reflexivity.
    - (* n = S n *)
      simpl. rewrite double_incr_bin.
      rewrite plus_n_Sm. simpl.
      rewrite IHn. reflexivity.
Qed.

Theorem nat_bin_inv:
  forall b, nat_to_bin (bin_to_nat b) = normalize b.
Proof.
  (* 9. Complete the proof. *)
  induction b.
  - (* b = Z *)
    reflexivity.
  - (* b = B0 b *)
    simpl. rewrite add_0_r.
    rewrite two_times_nat_to_double_bin.
    rewrite IHb. reflexivity.
  - (* b = B1 b *)
    simpl. rewrite add_0_r.
    rewrite two_times_nat_to_double_bin.
    rewrite IHb. reflexivity.
Qed.