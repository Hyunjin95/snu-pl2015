Require Export Assignment06_03.

(* problem #04: 10 points *)

(** **** Exercise: 1 star (override_shadow')  *)
Theorem override_shadow' : forall (X:Type) x1 x2 k1 k2 (f : nat->X),
  (override' (override' f k1 x2) k1 x1) k2 = (override' f k1 x1) k2.
Proof.
  unfold override'.
  intros.
  destruct (eq_nat_dec k1 k2).
  reflexivity.
  reflexivity.
Qed.
(** [] *)


