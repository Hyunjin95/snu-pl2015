(** **** Problem #1 : 2 stars (mult_S_1) *)
Theorem mult_S_1 : forall n m : nat,
  m = S n -> 
  m * (1 + n) = m * m.
Proof.
  intros.
  simpl.
  rewrite H.
  auto.
Qed.

(** **** Problem #2 : 1 star (zero_nbeq_plus_1) *)
Fixpoint beq_nat (n m : nat) : bool :=
  match n with
  | O => match m with
         | O => true
         | S m' => false
         end
  | S n' => match m with
            | O => false
            | S m' => beq_nat n' m'
            end
  end.

Theorem zero_nbeq_plus_1 : forall n : nat,
  beq_nat 0 (n + 1) = false.
Proof.
  intros.
  induction n.
  auto.
  simpl.
  auto.
Qed.

(** **** Problem #3 : 2 stars (boolean functions) *)
(** Use the tactics you have learned so far to prove the following 
    theorem about boolean functions. *)

Theorem negation_fn_applied_twice : 
  forall (f : bool -> bool), 
  (forall (x : bool), f x = negb x) ->
  forall (b : bool), f (f b) = b.
Proof.
  intros.
  rewrite H.
  rewrite H.
  destruct b.
  auto.
  auto.
Qed.

(** **** Problem #4 : 2 stars (andb_eq_orb) *)
(** Prove the following theorem.  (You may want to first prove a
    subsidiary lemma or two. Alternatively, remember that you do
    not have to introduce all hypotheses at the same time.) *)

Theorem andb_eq_orb : 
  forall (b c : bool),
  (andb b c = orb b c) ->
  b = c.
Proof.
  intros b c.
  destruct b.
  destruct c.
  auto.
  auto.
  auto.
Qed.

(** **** Problem #5 : 2 stars (basic_induction) *)

(** Prove the following lemmas using induction. You might need
    previously proven results. *)

Theorem plus_n_O : forall n : nat,
  n = n + 0.
Proof. 
  intros.
  induction n.
  auto.
  simpl.
  rewrite <- IHn.
  reflexivity.
Qed.

Theorem plus_n_Sm : forall n m : nat, 
  S (n + m) = n + (S m).
Proof. 
  intros.
  induction n.
  simpl.
  auto.
  simpl.
  rewrite IHn.
  reflexivity.
Qed.

Theorem plus_comm : forall n m : nat,
  n + m = m + n.
Proof.
  intros.
  induction n.
  auto.
  simpl.
  rewrite IHn.
  auto.
Qed.

Theorem plus_assoc : forall n m p : nat,
  n + (m + p) = (n + m) + p.
Proof.
  intros.
  induction n.
  auto.
  simpl.
  rewrite IHn.
  auto.
Qed.

(** **** Problem #6 : 2 stars (double_plus) *)

(** Consider the following function, which doubles its argument: *)

Fixpoint double (n:nat) :=
  match n with
  | O => O
  | S n' => S (S (double n'))
  end.

(** Use induction to prove this simple fact about [double]: *)

Lemma double_plus : forall n, double n = n + n .
Proof.
  intros.
  induction n.
  auto.
  simpl.
  rewrite IHn.
  auto.
Qed.

(** **** Problem #7 : 4 stars (mult_comm) *)
(** Use [assert] to help prove this theorem if necessary.  
    You shouldn't need to use induction. *)

Theorem plus_swap : forall n m p : nat, 
  n + (m + p) = m + (n + p).
Proof.
  intros.
  rewrite plus_assoc.
  rewrite plus_assoc.
  replace (n + m) with (m + n).
  auto.
  rewrite plus_comm.
  reflexivity.
Qed.

(** **** Problem #8 : 3 stars (mult_comm) *)

Theorem mult_plus_distr_r : forall n m p : nat,
  (n + m) * p = (n * p) + (m * p).
Proof.
  intros.
  induction p.
  assert (H: forall n, n * 0 = 0).
    intros.
    auto.
  rewrite H.
  rewrite H.
  rewrite H.
  auto.
  assert (H2: forall n p, n * (S p) = n + n * p).
    intros.
    induction n0.
    auto.
    simpl.
    rewrite IHn0.
    rewrite plus_swap.
    auto.
  rewrite H2.
  rewrite H2.
  rewrite H2.
  rewrite IHp.
  rewrite plus_assoc.
  rewrite plus_assoc.
  replace (n + m + n * p) with (n + n * p + m).
  auto.
  rewrite plus_comm.
  replace (n + m) with (m + n).
  rewrite plus_assoc.
  auto.
  rewrite plus_comm.
  reflexivity.
Qed.

Theorem mult_assoc : forall n m p : nat,
  n * (m * p) = (n * m) * p.
Proof.
  intros.
  induction n.
  auto.
  simpl.
  rewrite IHn.
  rewrite mult_plus_distr_r.
  reflexivity.
Qed.
Inductive natprod : Type :=
  pair : nat -> nat -> natprod.

Notation "( x , y )" := (pair x y).

Definition fst := 
  fun (p : natprod) =>
  match p with
  | (x, y) => x
  end.

Definition snd (p : natprod) : nat := 
  match p with
  | (x, y) => y
  end.

Definition swap_pair (p : natprod) : natprod := 
  match p with
  | (x,y) => (y,x)
  end.

(** **** Problem #9 : 1 star (snd_fst_is_swap) *)
Theorem snd_fst_is_swap : forall (p : natprod),
  (snd p, fst p) = swap_pair p.
Proof.
  intros.
  destruct p.
  reflexivity.
Qed.

(** **** Problem #10 : 1 star, optional (fst_swap_is_snd) *)
Theorem fst_swap_is_snd : forall (p : natprod),
  fst (swap_pair p) = snd p.
Proof.
  intros.
  destruct p.
  reflexivity.
Qed.