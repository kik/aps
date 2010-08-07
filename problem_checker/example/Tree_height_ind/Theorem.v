Require Import Definitions.

Theorem tree_height_ind:
  forall (A: Type) (P: Tree A -> Prop),
  (forall t, (forall s, height s < height t -> P s) -> P t) ->
  forall u, P u.
Proof.
Admitted.
