(* DO NOT Require Import other files. *)

Require Import Basics.


Module Poly.

Inductive list (X:Type) : Type :=
  | nil : list X
  | cons : X -> list X -> list X.

Fixpoint app (X : Type) (l1 l2 : list X)
                : (list X) :=
  match l1 with
  | nil      => l2
  | cons h t => cons X h (app X t l2)
  end.

Fixpoint snoc (X:Type) (l:list X) (v:X) : (list X) :=
  match l with
  | nil      => cons X v (nil X)
  | cons h t => cons X h (snoc X t v)
  end.

Fixpoint rev (X:Type) (l:list X) : list X :=
  match l with
  | nil      => nil X
  | cons h t => snoc X (rev X t) h
  end.

Fixpoint length (X:Type) (l:list X) : nat :=
  match l with
  | nil   => 0
  | cons h t => S (length X t)
  end.

Arguments nil {X}.
Arguments cons {X} _ _.  (* use underscore for argument position that has no name *)
Arguments length {X} l.
Arguments app {X} l1 l2.
Arguments rev {X} l. 
Arguments snoc {X} l v.

Notation "x :: y" := (cons x y)
                     (at level 60, right associativity).
Notation "[ ]" := nil.
Notation "[ x ; .. ; y ]" := (cons x .. (cons y []) ..).
Notation "x ++ y" := (app x y)
                     (at level 60, right associativity).

Fixpoint map {X Y:Type} (f:X->Y) (l:list X)
             : (list Y) :=
  match l with
  | []     => []
  | h :: t => (f h) :: (map f t)
  end.

Inductive prod (X Y : Type) : Type :=
  pair : X -> Y -> prod X Y.

Arguments pair {X} {Y} _ _.

Notation "( x , y )" := (pair x y).

Notation "X * Y" := (prod X Y) : type_scope.

Definition fst {X Y : Type} (p : X * Y) : X :=
  match p with (x,y) => x end.

Definition snd {X Y : Type} (p : X * Y) : Y :=
  match p with (x,y) => y end.

Fixpoint filter {X:Type} (test: X->bool) (l:list X)
                : (list X) :=
  match l with
  | []     => []
  | h :: t => 
    match test h with
    | true => h :: (filter test t)
    | false => filter test t
    end
  end.

Definition override {X: Type} (f: nat->X) (k:nat) (x:X) : nat->X:=
  fun (k':nat) => if beq_nat k k' then x else f k'.

Definition constfun {X: Type} (x: X) : nat->X :=
  fun (k:nat) => x.

Fixpoint fold {X Y:Type} (f: X->Y->Y) (l:list X) (b:Y) : Y :=
  match l with
  | nil => b
  | h :: t => f h (fold f t b)
  end.





(** **** Problem #1 (30 pts) : 2 stars, optional (poly_exercises) *)
(** Here are a few simple exercises, just like ones in the [Lists]
    chapter, for practice with polymorphism.  Fill in the definitions
    and complete the proofs below. *)

Fixpoint repeat {X : Type} (n : X) (count : nat) : list X :=
  match count with
  | 0 => nil
  | S n' => n :: (repeat n n')
  end.

Example test_repeat1:
  repeat true 2 = cons true (cons true nil).
  Proof. reflexivity. Qed.

Theorem nil_app : forall X:Type, forall l:list X,
  app [] l = l.
Proof.
  intros.
  induction l.
  simpl.
  reflexivity.
  simpl.
  reflexivity.
Qed.

Theorem snoc_with_append : forall X : Type,
                         forall l1 l2 : list X,
                         forall v : X,
  snoc (l1 ++ l2) v = l1 ++ (snoc l2 v).
Proof.
  intros.
  induction l1.
  simpl.
  reflexivity.
  simpl.
  rewrite IHl1.
  reflexivity.
Qed.














(** **** Problem #2 (10 pts) : 1 star, optional (hd_opt_poly) *)
(** Complete the definition of a polymorphic version of the
    [hd_opt] function from the last chapter. Be sure that it
    passes the unit tests below. *)

Definition hd_opt {X : Type} (l : list X)  : option X :=
  match l with
  | nil => None
  | h::t => Some h
  end.

(** Once again, to force the implicit arguments to be explicit,
    we can use [@] before the name of the function. *)

Check @hd_opt.

Example test_hd_opt1 :  hd_opt [1;2] = Some 1.
  Proof. reflexivity. Qed.
Example test_hd_opt2 :   hd_opt  [[1];[2]]  = Some [1].
  Proof. reflexivity. Qed.










(** **** Problem #3 (30 pts) : 2 stars, advanced (currying) *)
(** In Coq, a function [f : A -> B -> C] really has the type [A
    -> (B -> C)].  That is, if you give [f] a value of type [A], it
    will give you function [f' : B -> C].  If you then give [f'] a
    value of type [B], it will return a value of type [C].  This
    allows for partial application, as in [plus3].  Processing a list
    of arguments with functions that return functions is called
    _currying_, in honor of the logician Haskell Curry.

    Conversely, we can reinterpret the type [A -> B -> C] as [(A *
    B) -> C].  This is called _uncurrying_.  With an uncurried binary
    function, both arguments must be given at once as a pair; there is
    no partial application. *)

(** We can define currying as follows: *)

Definition prod_curry {X Y Z : Type}
  (f : X * Y -> Z) (x : X) (y : Y) : Z := f (x, y).

(** As an exercise, define its inverse, [prod_uncurry].  Then prove
    the theorems below to show that the two are inverses. *)

Definition prod_uncurry {X Y Z : Type}
  (f : X -> Y -> Z) (p : X * Y) : Z :=
  f (fst p) (snd p).

(** (Thought exercise: before running these commands, can you
    calculate the types of [prod_curry] and [prod_uncurry]?) *)

Check @prod_curry.
Check @prod_uncurry.

Theorem uncurry_curry : forall (X Y Z : Type) (f : X -> Y -> Z) x y,
  prod_curry (prod_uncurry f) x y = f x y.
Proof.
  intros.
  reflexivity.
Qed.

Theorem curry_uncurry : forall (X Y Z : Type)
                               (f : (X * Y) -> Z) (p : X * Y),
  prod_uncurry (prod_curry f) p = f p.
Proof.
  intros.
  destruct p.
  reflexivity.
Qed.

















(** **** Problem #4 (10 pts) : 2 stars (filter_even_gt7) *)

(** Use [filter] (instead of [Fixpoint]) to write a Coq function
    [filter_even_gt7] that takes a list of natural numbers as input
    and returns a list of just those that are even and greater than
    7. *)

Definition filter_even_gt7 (l : list nat) : list nat :=
  filter (fun x => andb (ble_nat 7 x) (evenb x)) l.

Example test_filter_even_gt7_1 :
  filter_even_gt7 [1;2;6;9;10;3;12;8] = [10;12;8].
  Proof. reflexivity. Qed.

Example test_filter_even_gt7_2 :
  filter_even_gt7 [5;2;6;19;129] = [].
  Proof. reflexivity. Qed.












(** **** Problem #5 (10 pts) : 3 stars (partition) *)
(** Use [filter] to write a Coq function [partition]:
  partition : forall X : Type,
              (X -> bool) -> list X -> list X * list X
   Given a set [X], a test function of type [X -> bool] and a [list
   X], [partition] should return a pair of lists.  The first member of
   the pair is the sublist of the original list containing the
   elements that satisfy the test, and the second is the sublist
   containing those that fail the test.  The order of elements in the
   two sublists should be the same as their order in the original
   list.
*)

Definition partition {X : Type} (test : X -> bool) (l : list X)
                     : list X * list X :=
  (filter test l, filter (fun x => negb (test x)) l).

Example test_partition1: partition oddb [1;2;3;4;5] = ([1;3;5], [2;4]).
  Proof. reflexivity. Qed.
Example test_partition2: partition (fun x => false) [5;9;0] = ([], [5;9;0]).
  Proof. reflexivity. Qed.











(** **** Problem #6 (10 pts) : 3 stars (map_rev) *)
(** Show that [map] and [rev] commute.  You may need to define an
    auxiliary lemma. *)

Lemma map_rev_sub0 : forall (X Y : Type) (f : X -> Y) (x: X) (l : list X),
  map f (snoc l x) = snoc (map f l) (f x).
Proof.
  intros.
  induction l.
  simpl.
  reflexivity.
  simpl.
  rewrite IHl.
  reflexivity.
Qed.

Theorem map_rev : forall (X Y : Type) (f : X -> Y) (l : list X),
  map f (rev l) = rev (map f l).
Proof.
  intros.
  induction l.
  simpl.
  reflexivity.
  simpl.
  rewrite map_rev_sub0.
  rewrite IHl.
  reflexivity.
Qed.
  











(** **** Problem #7 (10 pts) : 2 stars (flat_map) *)
(** The function [map] maps a [list X] to a [list Y] using a function
    of type [X -> Y].  We can define a similar function, [flat_map],
    which maps a [list X] to a [list Y] using a function [f] of type
    [X -> list Y].  Your definition should work by 'flattening' the
    results of [f], like so:
        flat_map (fun n => [n;n+1;n+2]) [1;5;10]
      = [1; 2; 3; 5; 6; 7; 10; 11; 12].
*)

Fixpoint flat_map {X Y:Type} (f:X -> list Y) (l:list X)
                   : (list Y) :=
  match l with
  | nil => nil
  | h::t => (f h)++(flat_map f t)
  end.

Example test_flat_map1:
  flat_map (fun n => [n;n;n]) [1;5;4]
  = [1; 1; 1; 5; 5; 5; 4; 4; 4].
  Proof. reflexivity. Qed.







(** **** Problem #8 (10 pts) : 1 star (override_example) *)
(** Before starting to work on the following proof, make sure you
    understand exactly what the theorem is saying and can paraphrase
    it in your own words.  The proof itself is straightforward. *)

Theorem override_example : forall (b:bool),
  (override (constfun b) 3 true) 2 = b.
Proof.
  unfold override.
  intros.
  simpl.
  unfold constfun.
  reflexivity.
Qed.








(** **** Problem #9 (10 pts) : 2 stars (override_neq) *)
Theorem override_neq : forall (X:Type) x1 x2 k1 k2 (f : nat->X),
  f k1 = x1 ->
  beq_nat k2 k1 = false ->
  (override f k2 x2) k1 = x1.
Proof.
  unfold override.
  intros.
  destruct (beq_nat k2 k1).
  inversion H0.
  apply H.
Qed.









(** **** Problem #10 (10 pts) : 2 stars (fold_length) *)
(** Many common functions on lists can be implemented in terms of
   [fold].  For example, here is an alternative definition of [length]: *)

Definition fold_length {X : Type} (l : list X) : nat :=
  fold (fun _ n => S n) l 0.

(** Prove the correctness of [fold_length]. *)

Theorem fold_length_correct : forall X (l : list X),
  fold_length l = length l.
Proof.
  intros.
  induction l.
  simpl.
  reflexivity.
  simpl.
  rewrite <- IHl.
  reflexivity.
Qed.












(** **** Problem #11 (20 pts) : 3 stars (fold_map) *)
(** We can also define [map] in terms of [fold].  Finish [fold_map]
    below. *)

Definition fold_map {X Y:Type} (f : X -> Y) (l : list X) : list Y :=
  fold (fun x y => (f x)::y) l [].

(** Prove the correctness of [fold_map]. *)

Theorem fold_map_correct : forall (X Y:Type) (f : X -> Y) (l : list X),
  fold_map f l = map f l.
Proof.
  intros.
  induction l.
  simpl.
  reflexivity.
  simpl.
  rewrite <- IHl.
  reflexivity.
Qed.



End Poly.











Require Import Poly.

Module MoreCoq.


(** **** Problem #12 (10 pts) : 2 stars, optional (silly_ex)  *)
(** Complete the following proof without using [simpl]. 
    Hint: Use the [apply] tactic. *)

Theorem silly_ex : 
     (forall n, evenb n = true -> oddb (S n) = true) ->
     evenb 3 = true ->
     oddb 4 = true.
Proof.
  intros.
  inversion H0.
Qed.









(** **** Problem #13 (10 pts) : 3 stars (apply_exercise1)  *)
(** Hint: you can use [apply] with previously defined lemmas, not
    just hypotheses in the context.  Remember that [SearchAbout] is
    your friend. *)

Theorem rev_exercise1 : forall (l l' : list nat),
     l = rev l' ->
     rev l = l'.
Proof.
  intros.
  rewrite <- rev_involutive.
  rewrite <- H.
  reflexivity.
Qed.








(** **** Problem #14 (10 pts) : 3 stars, optional (apply_with_exercise)  
    Hint: Use the [apply ... with ...] tactic. *)
Theorem trans_lt : forall (n m o : nat),
  n < m -> m < o -> n < o.
Proof.
  intros.
  exact (Lt.lt_trans _ _ _ H H0).
Qed.

Example trans_eq_exercise : forall (n m o p : nat),
     (minustwo o) < m ->
     (n + p) < (minustwo o) ->
     (n + p) < m. 
Proof.
  intros.
  apply trans_lt with (n := n+p) (m := minustwo o) (o := m).
  apply H0.
  apply H.
Qed.










(** **** Problem #15 (10 pts) : 1 star (sillyex1) 
    Hint: Use the [inversion] tactic. *) 
Example sillyex1 : forall (X : Type) (x y z : X) (l j : list X),
     x :: y :: l = z :: j ->
     y :: l = x :: j ->
     x = y.
Proof.
  intros.
  inversion H0.
  reflexivity.
Qed.










(** **** Problem #16 (10 pts) : 1 star (sillyex2)  
    Hint: use the [inversion] tactic. *)
Example sillyex2 : forall (X : Type) (x y z : X) (l j : list X),
     x :: y :: l = [] ->
     y :: l = z :: j ->
     x = z.
Proof.
  intros.
  inversion H0.
  inversion H.
Qed.







(** **** Problem #17 (10 pts) : 2 stars, optional (practice)  *)
(** Hint: if [inversion] does not work directly, do the case analysis first. *)
 
Theorem beq_nat_0_l : forall n,
   beq_nat 0 n = true -> n = 0.
Proof.
  intros.
  inversion H.
  destruct n.
  reflexivity.
  inversion H1.
Qed.















(** **** Problem #18 (10 pts) : 3 stars (plus_n_n_injective)  *)
(** Practice using "in" variants in this exercise. *)

Theorem plus_n_n_injective : forall n m,
     n + n = m + m ->
     n = m.
Proof.
  intros n. induction n as [| n'].
    (* Hint: use the [destruct] and [inversion] tactics. *)
    (* Hint: use the plus_n_Sm lemma *)
  simpl.
  intros.
  destruct m.
  reflexivity.
  simpl in H.
  inversion H.
  simpl.
  intros.
  destruct m.
  inversion H.
  rewrite <- plus_n_Sm in H.
  simpl in H.
  rewrite <- plus_n_Sm in H.
  inversion H.
  apply IHn' in H1.
  rewrite H1.
  reflexivity.
Qed.














(** **** Problem #19 (10 pts): 2 stars (beq_nat_true)  *)
Theorem beq_nat_true : forall n m,
    beq_nat n m = true -> n = m.
Proof.
  induction n.
  simpl.
  intros.
  destruct m.
  reflexivity.
  inversion H.
  simpl.
  intros.
  destruct m.
  inversion H.
  apply IHn in H.
  rewrite H.
  reflexivity.
Qed.















(** **** Problem #20 (10 pts) : 3 stars (gen_dep_practice)  *)
(** Prove this by induction on [l]. *)

Theorem index_after_last: forall (n : nat) (X : Type) (l : list X),
     length l = n ->
     index n l = None.
Proof.
  intros.
  generalize dependent n.
  induction l.
  simpl.
  intros.
  reflexivity.
  simpl.
  intros.
  destruct n.
  simpl.
  inversion H.
  simpl.
  apply IHl.
  inversion H.
  reflexivity.
Qed.
  












(** **** Problem #21 (10 pts) : 3 stars, optional (double_induction)  *)
(** Prove the following principle of induction over two naturals. *)

Theorem double_induction: forall (P : nat -> nat -> Prop), 
  P 0 0 ->
  (forall m, P m 0 -> P (S m) 0) ->
  (forall n, P 0 n -> P 0 (S n)) ->
  (forall m n, P m n -> P (S m) (S n)) ->
  forall m n, P m n.
Proof.
  induction m.
  induction n.
  apply H.
  apply H1.
  apply IHn.
  induction n.
  apply H0.
  apply IHm.
  intros.
  apply H2.
  apply IHm.
Qed.




(** **** Problem #22 (10 pts) : 1 star (override_shadow)  *)
Theorem override_shadow : forall (X:Type) x1 x2 k1 k2 (f : nat->X),
  (override (override f k1 x2) k1 x1) k2 = (override f k1 x1) k2.
Proof.
  unfold override.
  intros.
  destruct (beq_nat k1 k2).
  reflexivity.
  reflexivity.
Qed.













(** **** Problem #23 (10 pts) : 2 stars (destruct_eqn_practice)  *)
Theorem bool_fn_applied_thrice : 
  forall (f : bool -> bool) (b : bool), 
  f (f (f b)) = f b.
Proof.
  intros.
  destruct b eqn:h0.
  destruct (f true) eqn:h1.
  rewrite h1.
  apply h1.
  destruct (f false) eqn:h2.
  apply h1.
  apply h2.
  destruct (f false) eqn:h3.
  destruct (f true) eqn:h4.
  apply h4.
  apply h3.
  rewrite h3.
  apply h3.
Qed.









(** **** Problem #24 (10 pts) : 2 stars (override_same)  
    Hint: use the lemma [beq_nat_true]. *)
Theorem override_same : forall (X:Type) x1 k1 k2 (f : nat->X),
  f k1 = x1 -> 
  (override f k1 x1) k2 = f k2.
Proof.
  unfold override.
  intros.
  destruct (beq_nat k1 k2) eqn:h0.
  apply beq_nat_true in h0.
  rewrite h0 in H.
  rewrite H.
  reflexivity.
  reflexivity.
Qed.









(** **** Problem #25 (10 pts) : 3 stars, advanced (filter_exercise)  *)
(** This one is a bit challenging.  Pay attention to the form of your IH. *)

Theorem filter_exercise : forall (X : Type) (test : X -> bool)
                             (x : X) (l lf : list X),
     filter test l = x :: lf ->
     test x = true.
Proof.
  induction l.
  simpl.
  intros.
  inversion H.
  simpl.
  intros.
  destruct (test x0) eqn:h0.
  inversion H.
  rewrite H1 in h0.
  apply h0.
  apply IHl with (lf := lf).
  apply H.
Qed.


End MoreCoq.

