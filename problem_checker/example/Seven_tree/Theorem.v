Require Import Definitions.

Definition f: T7 -> T.
Admitted.

Definition g: T -> T7.
Admitted.

Theorem fg_id: forall t, f (g t) = t.
Proof.
Admitted.

Theorem gf_id: forall t, g (f t) = t.
Proof.
Admitted.

