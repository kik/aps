Require Import Definitions.
Require Import Arith.
Require Import Omega.
Require Import ConstructiveEpsilon.

Definition P (x: nat -> nat) n m :=
  n <= m -> x n = x m.

Lemma dec_1: forall x n m, decidable (P x n m).
Proof.
  intros.
  unfold P. red.
  destruct (eq_nat_dec (x n) (x m)).
  left.
  auto.
  destruct (le_lt_dec n m).
  right.
  intro.
  apply H in l.
  auto.
  left.
  intros.
  apply False_ind.
  omega.
Qed.

Lemma dec_2: LPO -> forall x n, decidable(exists m, ~P x n m).
Proof.
  intros HLPO ? ?.
  destruct (HLPO (P x n)).
  apply dec_1.
  right.
  intro.
  destruct H.
  auto.
  left. auto.
Qed.

Theorem LPO_ICD: LPO -> ICD.
Proof.
  red.
  intros HLPO ? ?.
  destruct (HLPO (fun n => exists m, ~P x n m)).
  apply dec_2. auto.
  right.
  red.
  intros.
  destruct (e n) as [m ?].
  exists m.
  unfold P in H0.
  destruct (le_lt_dec n m).
  destruct (eq_nat_dec (x n) (x m)).
  apply False_ind. auto.
  specialize (H n m l).
  omega.
  elim H0.
  intros.
  apply False_ind.  omega.
  left.
  apply constructive_indefinite_description_nat in e.
  destruct e as [n ?].
  exists n.
  destruct (HLPO (P x n)).
  apply dec_1.
  auto.
  contradiction.
  intros.
  destruct (dec_2 HLPO x x0); auto.
Qed.

Section I2L.
  Variable Q: nat -> Prop.
  Variable decQ : forall n, decidable (Q n).
  Definition x: nat -> nat := fun n =>
     if decQ n then 0 else 1.
  Fixpoint s n :=
     match n with
     | O => 0
     | S m => s m + x m
     end.
  Lemma inc_s_aux: forall n m, s n <= s (n + m).
  Proof.
    induction m.
    replace (n+0) with n by auto with arith.
    auto with arith.
    replace (n + S m) with (S (n + m)) by auto with arith.
    simpl.
    omega.
  Qed.
  Lemma inc_s: increasing s.
  Proof.
    red.
    intros.
    replace m with (n + (m - n)) by omega.
    apply inc_s_aux.
  Qed.
  Lemma LPO_x: ICD -> {forall n, s n = 0} + {exists n, s n > 0}.
  Proof.
    intros HICD.
    destruct (HICD s).
    exact inc_s.
    destruct c as [n H].
    destruct (eq_nat_dec (s n) 0).
    left.
    intro m.
    destruct (le_lt_dec n m).
    rewrite <- H; auto.
    cut (s m <= s n).
    intro. omega.
    apply inc_s.
    omega.
    right.
    exists n.
    omega.
    right.
    destruct (d 0) as [n H].
    exists n.
    omega.
  Qed.
  Lemma Qall: (forall n, s n = 0) -> forall n, Q n.
  Proof.
    intros.
    specialize (H (S n)).
    simpl in H. unfold x in H.
    destruct (decQ n).
    auto.
    apply False_ind. omega.
  Qed.
  Lemma Qnotall: (exists n, s n > 0) -> exists n, ~Q n.
  Proof.
    intros.
    destruct H as [n H].
    induction n.
    simpl in H. inversion H.
    destruct (zerop (s n)).
    exists n.
    simpl in H. unfold x in H.
    destruct (decQ n).
    apply False_ind. omega.
    auto.
    apply IHn.
    omega.
  Qed.
  Lemma LPO_y: ICD -> {forall n, Q n} + {exists n, ~Q n}.
  Proof.
    intro HICD.
    destruct (LPO_x HICD).
    left. apply Qall. auto.
    right. apply Qnotall. auto.
  Qed.
End I2L.

Theorem ICD_LPO: ICD -> LPO.
Proof.
  red.
  intros HICD Q H.
  apply LPO_y; auto.
Qed.
