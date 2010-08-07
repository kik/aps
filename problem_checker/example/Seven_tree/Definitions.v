Inductive T : Set :=
| Leaf: T
| Node: T -> T -> T.

Definition T7 := (T*T*T*T*T*T*T)%type.

