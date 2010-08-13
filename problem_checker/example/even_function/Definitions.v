Require Import ZArith.
Open Scope Z_scope.

Definition even_function {A: Type} (f: Z -> A) := forall x, f x = f (-x).
