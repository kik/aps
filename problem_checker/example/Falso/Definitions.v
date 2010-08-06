Axiom Falso: False.

Fixpoint pow a n :=
match n with
| O => 1
| S m => a * pow a m
end.
