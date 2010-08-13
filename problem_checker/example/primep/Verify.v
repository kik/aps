Require Import ZArith.
Open Scope Z_scope.

Definition check_prime_dec (x: Z): { prime x } + { ~prime x } := prime_dec x.
