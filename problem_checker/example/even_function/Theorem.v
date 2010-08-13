Require Import Definitions.
Require Import ZArith.
Open Scope Z_scope.

Theorem even_pos: forall (A: Type) (f: Z -> A) (P: A -> Prop), even_function f ->
  (forall x, x >= 0 -> P (f x)) -> forall x, P (f x).
Admitted.
