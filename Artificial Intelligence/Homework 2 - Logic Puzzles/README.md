## 2. Puzzle B
### Assumptions and Goal
1. all x (entered(x) & -vip(x) -> exists y (customofficial(y) & searched(y,x))).
2. exists x (drug_pusher(x) & entered(x) & all y (searched(y,x) -> customofficial(y) & drug_pusher(y))).
3. all x drug_pusher(x) -> -vip(x).
4. (Conclusion) exists x customofficial(x) & drug_pusher(x).

### Input
```
formulas(sos).
  all x exists y ((entered(x) & -vip(x)) -> (customofficial(y) & searched(y,x))).
  exists x all y (drug_pusher(x) & entered(x) & (searched(y,x) -> customofficial(y))).
  all x (drug_pusher(x) -> -vip(x)).
end_of_list.

formulas(goals).
  exists x (customofficial(x) & drug_pusher(x)).
end_of_list.
```

### Output
```
============================== Prover9 ===============================
Prover9 (64) version 2009-11A, November 2009.
Process 80 was started by Christian on DESKTOP-U2JP5RS,
Tue Mar  7 17:26:19 2023
The command was "prover9 -f puzzleB.in".
============================== end of head ===========================

============================== INPUT =================================

% Reading from file puzzleB.in


formulas(sos).
(all x (entered(x) & -vip(x) -> (exists y (customofficial(y) & searched(y,x))))).
(exists x (drug_pusher(x) & entered(x) & (all y (searched(y,x) -> customofficial(y) & drug_pusher(y))))).
(all x (drug_pusher(x) -> -vip(x))).
end_of_list.

formulas(goals).
(exists x (customofficial(x) & drug_pusher(x))).
end_of_list.

============================== end of input ==========================

============================== PROCESS NON-CLAUSAL FORMULAS ==========

% Formulas that are not ordinary clauses:
1 (all x (entered(x) & -vip(x) -> (exists y (customofficial(y) & searched(y,x))))) # label(non_clause).  [assumption].
2 (exists x (drug_pusher(x) & entered(x) & (all y (searched(y,x) -> customofficial(y) & drug_pusher(y))))) # label(non_clause).  [assumption].
3 (all x (drug_pusher(x) -> -vip(x))) # label(non_clause).  [assumption].
4 (exists x (customofficial(x) & drug_pusher(x))) # label(non_clause) # label(goal).  [goal].

============================== end of process non-clausal formulas ===

============================== PROCESS INITIAL CLAUSES ===============

% Clauses before input processing:

formulas(usable).
end_of_list.

formulas(sos).
-entered(x) | vip(x) | customofficial(f1(x)).  [clausify(1)].
-entered(x) | vip(x) | searched(f1(x),x).  [clausify(1)].
drug_pusher(c1).  [clausify(2)].
entered(c1).  [clausify(2)].
-searched(x,c1) | customofficial(x).  [clausify(2)].
-searched(x,c1) | drug_pusher(x).  [clausify(2)].
-drug_pusher(x) | -vip(x).  [clausify(3)].
-customofficial(x) | -drug_pusher(x).  [deny(4)].
end_of_list.

formulas(demodulators).
end_of_list.

============================== PREDICATE ELIMINATION =================

Eliminating entered/1
5 entered(c1).  [clausify(2)].
6 -entered(x) | vip(x) | customofficial(f1(x)).  [clausify(1)].
7 -entered(x) | vip(x) | searched(f1(x),x).  [clausify(1)].
Derived: vip(c1) | customofficial(f1(c1)).  [resolve(5,a,6,a)].
Derived: vip(c1) | searched(f1(c1),c1).  [resolve(5,a,7,a)].

Eliminating drug_pusher/1
8 -drug_pusher(x) | -vip(x).  [clausify(3)].
9 drug_pusher(c1).  [clausify(2)].
10 -searched(x,c1) | drug_pusher(x).  [clausify(2)].
Derived: -vip(c1).  [resolve(8,a,9,a)].
Derived: -vip(x) | -searched(x,c1).  [resolve(8,a,10,b)].
11 -customofficial(x) | -drug_pusher(x).  [deny(4)].
Derived: -customofficial(c1).  [resolve(11,b,9,a)].
Derived: -customofficial(x) | -searched(x,c1).  [resolve(11,b,10,b)].

Eliminating searched/2
12 vip(c1) | searched(f1(c1),c1).  [resolve(5,a,7,a)].
13 -searched(x,c1) | customofficial(x).  [clausify(2)].
Derived: vip(c1) | customofficial(f1(c1)).  [resolve(12,b,13,a)].
14 -vip(x) | -searched(x,c1).  [resolve(8,a,10,b)].
Derived: -vip(f1(c1)) | vip(c1).  [resolve(14,b,12,b)].
15 -customofficial(x) | -searched(x,c1).  [resolve(11,b,10,b)].
Derived: -customofficial(f1(c1)) | vip(c1).  [resolve(15,b,12,b)].

Eliminating customofficial/1
16 -customofficial(c1).  [resolve(11,b,9,a)].
17 vip(c1) | customofficial(f1(c1)).  [resolve(5,a,6,a)].
18 vip(c1) | customofficial(f1(c1)).  [resolve(12,b,13,a)].
19 -customofficial(f1(c1)) | vip(c1).  [resolve(15,b,12,b)].
Derived: vip(c1) | vip(c1).  [resolve(19,a,17,b)].

============================== end predicate elimination =============

Auto_denials:  (non-Horn, no changes).

Term ordering decisions:
Predicate symbol precedence:  predicate_order([ vip ]).
Function symbol precedence:  function_order([ c1, f1 ]).
After inverse_order:  (no changes).
Unfolding symbols: (none).

Auto_inference settings:
  % set(binary_resolution).  % (non-Horn)
  % set(neg_ur_resolution).  % (non-Horn, less than 100 clauses)

Auto_process settings:
  % set(factor).  % (non-Horn)
  % set(unit_deletion).  % (non-Horn)

kept:      20 -vip(c1).  [resolve(8,a,9,a)].
           21 -vip(f1(c1)) | vip(c1).  [resolve(14,b,12,b)].
kept:      22 -vip(f1(c1)).  [copy(21),unit_del(b,20)].
           23 vip(c1) | vip(c1).  [resolve(19,a,17,b)].

============================== PROOF =================================

% Proof 1 at 0.00 (+ 0.02) seconds.
% Length of proof is 18.
% Level of proof is 5.
% Maximum clause weight is 2.000.
% Given clauses 0.

1 (all x (entered(x) & -vip(x) -> (exists y (customofficial(y) & searched(y,x))))) # label(non_clause).  [assumption].
2 (exists x (drug_pusher(x) & entered(x) & (all y (searched(y,x) -> customofficial(y) & drug_pusher(y))))) # label(non_clause).  [assumption].
3 (all x (drug_pusher(x) -> -vip(x))) # label(non_clause).  [assumption].
4 (exists x (customofficial(x) & drug_pusher(x))) # label(non_clause) # label(goal).  [goal].
5 entered(c1).  [clausify(2)].
6 -entered(x) | vip(x) | customofficial(f1(x)).  [clausify(1)].
7 -entered(x) | vip(x) | searched(f1(x),x).  [clausify(1)].
8 -drug_pusher(x) | -vip(x).  [clausify(3)].
9 drug_pusher(c1).  [clausify(2)].
10 -searched(x,c1) | drug_pusher(x).  [clausify(2)].
11 -customofficial(x) | -drug_pusher(x).  [deny(4)].
12 vip(c1) | searched(f1(c1),c1).  [resolve(5,a,7,a)].
15 -customofficial(x) | -searched(x,c1).  [resolve(11,b,10,b)].
17 vip(c1) | customofficial(f1(c1)).  [resolve(5,a,6,a)].
19 -customofficial(f1(c1)) | vip(c1).  [resolve(15,b,12,b)].
20 -vip(c1).  [resolve(8,a,9,a)].
23 vip(c1) | vip(c1).  [resolve(19,a,17,b)].
24 $F.  [copy(23),merge(b),unit_del(a,20)].

============================== end of proof ==========================

============================== STATISTICS ============================

Given=0. Generated=3. Kept=2. proofs=1.
Usable=0. Sos=0. Demods=0. Limbo=2, Disabled=18. Hints=0.
Kept_by_rule=0, Deleted_by_rule=0.
Forward_subsumed=0. Back_subsumed=0.
Sos_limit_deleted=0. Sos_displaced=0. Sos_removed=0.
New_demodulators=0 (0 lex), Back_demodulated=0. Back_unit_deleted=0.
Demod_attempts=0. Demod_rewrites=0.
Res_instance_prunes=0. Para_instance_prunes=0. Basic_paramod_prunes=0.
Nonunit_fsub_feature_tests=0. Nonunit_bsub_feature_tests=0.
Megabytes=0.04.
User_CPU=0.00, System_CPU=0.02, Wall_clock=0.

============================== end of statistics =====================

============================== end of search =========================

THEOREM PROVED

Exiting with 1 proof.

Process 80 exit (max_proofs) Tue Mar  7 17:26:19 2023
```

### Conclusion
To prove the conclusion: "There exists someone who is a custom official and a drug_pusher", we use resolution refutation to prove that the negation cannot be true within the model. The negation of the conclusion is that, for all people, they must be one of the following: not a custom official, not a drug_pusher, or neither. The logical steps are shown in the proof section of the Prover9 output. Prover9 concludes that, when added to the model, the negation results in vip(c1) and -vip(c1) both being asserted. These negate and return NIL, thus we know the negation must be false and the original conclusion must be true.

## 3. Puzzle C
1. all x all y (Pizza(y) & Eats(x,y) -> Happy(x)).
2. all x exists y (Foodie(x) -> (Pizza(y) | Salad(y)) & Eats(x,y)).
3. all x all y (Salad(y) & Eats(x,y) -> Healthy(x)).
4. all x (Healthy(x) -> Gyms(x)).
5. all x all y (Nice(x) -> Happy(y) & -Dated(x,y)).
6. Nice(Ann) & Foodie(Peter).
7. (Conclusion) Gyms(Peter) -> -Dated(Ann, Peter).

### Input
```
formulas(sos).
  all x ((exists y (Pizza(y) & Eats(x,y))) -> Happy(x)).
  all x (Foodie(x) -> (exists y (Eats(x,y) & (Pizza(y) | Salad(y))))).
  all x (exists y (Salad(y) & Eats(x,y)) -> Healthy(x)).
  all x (Healthy(x) -> Gyms(x)).
  all x all y ((Nice(x) & Happy(y)) -> -Dated(x,y)).
  Nice(Ann) & Foodie(Peter).
end_of_list.

formulas(goals).
  -Gyms(Peter) -> -Dated(Ann, Peter).
end_of_list.
```

### Output
```
============================== Prover9 ===============================
Prover9 (64) version 2009-11A, November 2009.
Process 131 was started by Christian on DESKTOP-U2JP5RS,
Mon Mar 20 14:01:45 2023
The command was "prover9 -f puzzleC.in".
============================== end of head ===========================

============================== INPUT =================================

% Reading from file puzzleC.in


formulas(sos).
(all x ((exists y (Pizza(y) & Eats(x,y))) -> Happy(x))).
(all x (Foodie(x) -> (exists y (Eats(x,y) & (Pizza(y) | Salad(y)))))).
(all x ((exists y (Salad(y) & Eats(x,y))) -> Healthy(x))).
(all x (Healthy(x) -> Gyms(x))).
(all x all y (Nice(x) & Happy(y) -> -Dated(x,y))).
Nice(Ann) & Foodie(Peter).
end_of_list.

formulas(goals).
-Gyms(Peter) -> -Dated(Ann,Peter).
end_of_list.

============================== end of input ==========================

============================== PROCESS NON-CLAUSAL FORMULAS ==========

% Formulas that are not ordinary clauses:
1 (all x ((exists y (Pizza(y) & Eats(x,y))) -> Happy(x))) # label(non_clause).  [assumption].
2 (all x (Foodie(x) -> (exists y (Eats(x,y) & (Pizza(y) | Salad(y)))))) # label(non_clause).  [assumption].
3 (all x ((exists y (Salad(y) & Eats(x,y))) -> Healthy(x))) # label(non_clause).  [assumption].
4 (all x (Healthy(x) -> Gyms(x))) # label(non_clause).  [assumption].
5 (all x all y (Nice(x) & Happy(y) -> -Dated(x,y))) # label(non_clause).  [assumption].
6 Nice(Ann) & Foodie(Peter) # label(non_clause).  [assumption].
7 -Gyms(Peter) -> -Dated(Ann,Peter) # label(non_clause) # label(goal).  [goal].

============================== end of process non-clausal formulas ===

============================== PROCESS INITIAL CLAUSES ===============

% Clauses before input processing:

formulas(usable).
end_of_list.

formulas(sos).
-Pizza(x) | -Eats(y,x) | Happy(y).  [clausify(1)].
-Foodie(x) | Eats(x,f1(x)).  [clausify(2)].
-Foodie(x) | Pizza(f1(x)) | Salad(f1(x)).  [clausify(2)].
-Salad(x) | -Eats(y,x) | Healthy(y).  [clausify(3)].
-Healthy(x) | Gyms(x).  [clausify(4)].
-Nice(x) | -Happy(y) | -Dated(x,y).  [clausify(5)].
Nice(Ann).  [clausify(6)].
Foodie(Peter).  [clausify(6)].
-Gyms(Peter).  [deny(7)].
Dated(Ann,Peter).  [deny(7)].
end_of_list.

formulas(demodulators).
end_of_list.

============================== PREDICATE ELIMINATION =================

Eliminating Pizza/1
8 -Foodie(x) | Pizza(f1(x)) | Salad(f1(x)).  [clausify(2)].
9 -Pizza(x) | -Eats(y,x) | Happy(y).  [clausify(1)].
Derived: -Foodie(x) | Salad(f1(x)) | -Eats(y,f1(x)) | Happy(y).  [resolve(8,b,9,a)].

Eliminating Foodie/1
10 Foodie(Peter).  [clausify(6)].
11 -Foodie(x) | Eats(x,f1(x)).  [clausify(2)].
Derived: Eats(Peter,f1(Peter)).  [resolve(10,a,11,a)].
12 -Foodie(x) | Salad(f1(x)) | -Eats(y,f1(x)) | Happy(y).  [resolve(8,b,9,a)].
Derived: Salad(f1(Peter)) | -Eats(x,f1(Peter)) | Happy(x).  [resolve(12,a,10,a)].

Eliminating Salad/1
13 Salad(f1(Peter)) | -Eats(x,f1(Peter)) | Happy(x).  [resolve(12,a,10,a)].
14 -Salad(x) | -Eats(y,x) | Healthy(y).  [clausify(3)].
Derived: -Eats(x,f1(Peter)) | Happy(x) | -Eats(y,f1(Peter)) | Healthy(y).  [resolve(13,a,14,a)].

Eliminating Healthy/1
15 -Eats(x,f1(Peter)) | Happy(x) | -Eats(y,f1(Peter)) | Healthy(y).  [resolve(13,a,14,a)].
16 -Healthy(x) | Gyms(x).  [clausify(4)].
Derived: -Eats(x,f1(Peter)) | Happy(x) | -Eats(y,f1(Peter)) | Gyms(y).  [resolve(15,d,16,a)].

Eliminating Nice/1
17 Nice(Ann).  [clausify(6)].
18 -Nice(x) | -Happy(y) | -Dated(x,y).  [clausify(5)].
Derived: -Happy(x) | -Dated(Ann,x).  [resolve(17,a,18,a)].

Eliminating Gyms/1
19 -Eats(x,f1(Peter)) | Happy(x) | -Eats(y,f1(Peter)) | Gyms(y).  [resolve(15,d,16,a)].
20 -Gyms(Peter).  [deny(7)].
Derived: -Eats(x,f1(Peter)) | Happy(x) | -Eats(Peter,f1(Peter)).  [resolve(19,d,20,a)].

Eliminating Dated/2
21 -Happy(x) | -Dated(Ann,x).  [resolve(17,a,18,a)].
22 Dated(Ann,Peter).  [deny(7)].
Derived: -Happy(Peter).  [resolve(21,b,22,a)].

Eliminating Happy/1
23 -Happy(Peter).  [resolve(21,b,22,a)].
24 -Eats(x,f1(Peter)) | Happy(x) | -Eats(Peter,f1(Peter)).  [resolve(19,d,20,a)].
Derived: -Eats(Peter,f1(Peter)) | -Eats(Peter,f1(Peter)).  [resolve(23,a,24,b)].

============================== end predicate elimination =============

Auto_denials:  (no changes).

Term ordering decisions:
Predicate symbol precedence:  predicate_order([ Eats ]).
Function symbol precedence:  function_order([ Peter, f1 ]).
After inverse_order:  (no changes).
Unfolding symbols: (none).

Auto_inference settings:
  % set(neg_binary_resolution).  % (HNE depth_diff=0)
  % clear(ordered_res).  % (HNE depth_diff=0)
  % set(ur_resolution).  % (HNE depth_diff=0)
    % set(ur_resolution) -> set(pos_ur_resolution).
    % set(ur_resolution) -> set(neg_ur_resolution).

Auto_process settings:
  % set(unit_deletion).  % (Horn set with negative nonunits)

kept:      25 Eats(Peter,f1(Peter)).  [resolve(10,a,11,a)].
           26 -Eats(Peter,f1(Peter)) | -Eats(Peter,f1(Peter)).  [resolve(23,a,24,b)].

============================== PROOF =================================

% Proof 1 at 0.02 (+ 0.00) seconds.
% Length of proof is 27.
% Level of proof is 8.
% Maximum clause weight is 4.000.
% Given clauses 0.

1 (all x ((exists y (Pizza(y) & Eats(x,y))) -> Happy(x))) # label(non_clause).  [assumption].
2 (all x (Foodie(x) -> (exists y (Eats(x,y) & (Pizza(y) | Salad(y)))))) # label(non_clause).  [assumption].
3 (all x ((exists y (Salad(y) & Eats(x,y))) -> Healthy(x))) # label(non_clause).  [assumption].
4 (all x (Healthy(x) -> Gyms(x))) # label(non_clause).  [assumption].
5 (all x all y (Nice(x) & Happy(y) -> -Dated(x,y))) # label(non_clause).  [assumption].
6 Nice(Ann) & Foodie(Peter) # label(non_clause).  [assumption].
7 -Gyms(Peter) -> -Dated(Ann,Peter) # label(non_clause) # label(goal).  [goal].
8 -Foodie(x) | Pizza(f1(x)) | Salad(f1(x)).  [clausify(2)].
9 -Pizza(x) | -Eats(y,x) | Happy(y).  [clausify(1)].
10 Foodie(Peter).  [clausify(6)].
11 -Foodie(x) | Eats(x,f1(x)).  [clausify(2)].
12 -Foodie(x) | Salad(f1(x)) | -Eats(y,f1(x)) | Happy(y).  [resolve(8,b,9,a)].
13 Salad(f1(Peter)) | -Eats(x,f1(Peter)) | Happy(x).  [resolve(12,a,10,a)].
14 -Salad(x) | -Eats(y,x) | Healthy(y).  [clausify(3)].
15 -Eats(x,f1(Peter)) | Happy(x) | -Eats(y,f1(Peter)) | Healthy(y).  [resolve(13,a,14,a)].
16 -Healthy(x) | Gyms(x).  [clausify(4)].
17 Nice(Ann).  [clausify(6)].
18 -Nice(x) | -Happy(y) | -Dated(x,y).  [clausify(5)].
19 -Eats(x,f1(Peter)) | Happy(x) | -Eats(y,f1(Peter)) | Gyms(y).  [resolve(15,d,16,a)].
20 -Gyms(Peter).  [deny(7)].
21 -Happy(x) | -Dated(Ann,x).  [resolve(17,a,18,a)].
22 Dated(Ann,Peter).  [deny(7)].
23 -Happy(Peter).  [resolve(21,b,22,a)].
24 -Eats(x,f1(Peter)) | Happy(x) | -Eats(Peter,f1(Peter)).  [resolve(19,d,20,a)].
25 Eats(Peter,f1(Peter)).  [resolve(10,a,11,a)].
26 -Eats(Peter,f1(Peter)) | -Eats(Peter,f1(Peter)).  [resolve(23,a,24,b)].
27 $F.  [copy(26),merge(b),unit_del(a,25)].

============================== end of proof ==========================

============================== STATISTICS ============================

Given=0. Generated=2. Kept=1. proofs=1.
Usable=0. Sos=0. Demods=0. Limbo=1, Disabled=19. Hints=0.
Kept_by_rule=0, Deleted_by_rule=0.
Forward_subsumed=0. Back_subsumed=0.
Sos_limit_deleted=0. Sos_displaced=0. Sos_removed=0.
New_demodulators=0 (0 lex), Back_demodulated=0. Back_unit_deleted=0.
Demod_attempts=0. Demod_rewrites=0.
Res_instance_prunes=0. Para_instance_prunes=0. Basic_paramod_prunes=0.
Nonunit_fsub_feature_tests=0. Nonunit_bsub_feature_tests=0.
Megabytes=0.04.
User_CPU=0.02, System_CPU=0.00, Wall_clock=0.

============================== end of statistics =====================

============================== end of search =========================

THEOREM PROVED

Exiting with 1 proof.

Process 131 exit (max_proofs) Mon Mar 20 14:01:45 2023
```

### Conclusion
To prove the conclusion: "If Peter does not go to the gym then Ann does not date Peter", we use resolution refutation to prove that the negation cannot be true within the model. The negation of the conclusion is that Peter does not go to the gym, then Ann dates himr. The logical steps are shown in the proof section of the Prover9 output. Prover9 concludes that, when added to the model, the negation results in Dated(Ann, Peter) and -Dated(Ann, Peter) both being asserted. These negate and return NIL, thus we know the negation must be false and the original conclusion must be true.
