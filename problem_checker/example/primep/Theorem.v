Require Import Definitions.
Require Import ZArith.
Open Scope Z_scope.

Definition decidable (P: Prop) := {P} + {~P}.

Lemma bounded_dec: forall P a b,
  (forall x, a <= x <= b -> decidable (P x)) ->
  { x | a <= x <= b & P x} + { forall x, a <= x <= b -> ~P x }.
Proof.
  intros P a b.
  destruct (Z_le_dec a b).
  pattern b.
  apply Zlt_lower_bound_rec with a; auto.
  intros.
  assert ({t | a <= t <= x-1 & P t} + {forall t, a <= t <= x-1 -> ~P t}).
  destruct (Z_eq_dec a x).
  right. intros. intro. omega.
  apply H. omega.
  intros. apply H1. omega.
  destruct H2 as [[t [? ?]]|?].
  left. exists t. omega. auto.
  destruct (H1 x). omega.
  left. exists x. auto with zarith. auto.
  right.
  intros.
  destruct (Z_eq_dec x0 x).
  congruence.
  apply n. omega.
  right.
  intros. intro. omega.
Qed.

Lemma factor: forall p x y, p >= 2 -> p = x*y -> x > 0 -> 0 < x <= p /\ 0 < y <= p.
Proof.
  intros.
  assert (0 < y).
  apply Zmult_lt_0_reg_r with x.
  omega.
  rewrite Zmult_comm. omega.
  constructor.
  constructor. auto with zarith.
  rewrite H0.
  rewrite <- (Zmult_1_r x) at 1.
  auto with zarith.
  constructor. auto.
  rewrite H0.
  rewrite <- (Zmult_1_l y) at 1.
  auto with zarith.
Qed.  

Definition prime_dec (x: Z): { prime x } + { ~prime x }.
Proof.
  intros.
  destruct (Z_ge_dec x 2).
  destruct (bounded_dec (fun t => exists s,  x = t*s ) 2 (x-1)).
  intros.
  destruct (bounded_dec (fun s => x = x0*s) 1 x).
  intros. red. apply Z_eq_dec.
  left. destruct s. exists x1. auto.
  right. intro. destruct H0.
  apply n with x1.
  cut (0 < x1 <= x). intro. omega.
  destruct factor with x x0 x1; auto. omega.
  auto.
  right. unfold prime. intro.
  destruct s as [x0 ? [x1 ?]]. destruct H.
  rewrite <- (H1 x0 x1) in a |-; auto.
  omega. omega.
  left. unfold prime.
  constructor. auto.
  intros.
  destruct (Z_eq_dec x0 x). auto.
  apply False_ind.
  destruct factor with x x0 y; auto. omega.
  apply n with x0. omega.
  exists y. auto.
  right. unfold prime. intro.
  tauto.
Qed.
