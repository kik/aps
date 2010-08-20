Require Import ZArith.
Open Scope Z_scope.

Definition prime (p: Z) := p >= 2 /\ (forall x y, p = x*y -> x > 1 -> x = p).
