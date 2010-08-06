Require Import Definitions.

Theorem Fermat's_Last_Theorem:
  forall (a b c n: nat), n > 2 -> pow a n + pow b n = pow c n ->
  a = 0 /\ b = 0 /\ c = 0.
Proof.
Admitted.
