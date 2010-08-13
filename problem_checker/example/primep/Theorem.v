Require Import Definitions.
Require Import ZArith.
Open Scope Z_scope.

Definition prime_dec (x: Z): { prime x } + { ~prime x }.
Admitted.
