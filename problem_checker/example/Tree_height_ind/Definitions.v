Require Import Arith.Max.

Inductive Tree (A: Type) : Type :=
| Leaf: A -> Tree A
| Node: Tree A -> Tree A -> Tree A.

Fixpoint height {A: Type} (t: Tree A) :=
match t with
| Leaf _ => O
| Node x y => S (max (height x) (height y))
end.

