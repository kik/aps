Definition decidable (P: Prop) := {P} + {~P}.

Definition LPO := forall (P: nat -> Prop),
  (forall n, decidable (P n)) ->
  {forall n, P n} + {exists n, ~P n}.

Definition increasing (x: nat -> nat) := forall n m, n <= m -> x n <= x m.
Definition convergent (x: nat -> nat) := { n | forall m, n <= m -> x n = x m }.
Definition divergent  (x: nat -> nat) := forall n, exists m, x n < x m.

Definition ICD := forall (x: nat -> nat),
  increasing x -> convergent x + {divergent x}.

