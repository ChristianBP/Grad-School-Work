## 2. Puzzle B
1. all x exists y (entered(x) & -vip(x) -> customofficial(y) & searched(y,x)).
2. exists x all y (drug_pusher(x) & entered(x) & (searched(y,x) -> customofficial(y))).
3. all x drug_pusher(x) -> -vip(x).
4. (Conclusion) exists x customofficial(x) & drug_pusher(x).

### Input
---
formulas(sos).
  all x exists y ((entered(x) & -vip(x)) -> (customofficial(y) & searched(y,x))).
  exists x all y (drug_pusher(x) & entered(x) & (searched(y,x) -> customofficial(y))).
  all x (drug_pusher(x) -> -vip(x)).
end_of_list.

formulas(goals).
  exists x (customofficial(x) & drug_pusher(x)).
end_of_list.
---

### Output
---
============================== Prover9 ===============================
Prover9 (64) version 2009-11A, November 2009.
Process 5506 was started by Christian on DESKTOP-U2JP5RS,
Sun Mar  5 23:32:33 2023
The command was "prover9 -f puzzleB.in".
============================== end of head ===========================

============================== INPUT =================================

% Reading from file puzzleB.in


formulas(sos).
(all x exists y (entered(x) & -vip(x) -> customofficial(y) & searched(y,x))).
(exists x all y (drug_pusher(x) & entered(x) & (searched(y,x) -> customofficial(y)))).
(all x (drug_pusher(x) -> -vip(x))).
end_of_list.

formulas(goals).
(exists x (customofficial(x) & drug_pusher(x))).
end_of_list.

============================== end of input ==========================

============================== PROCESS NON-CLAUSAL FORMULAS ==========

% Formulas that are not ordinary clauses:
1 (all x exists y (entered(x) & -vip(x) -> customofficial(y) & searched(y,x))) # label(non_clause).  [assumption].
2 (exists x all y (drug_pusher(x) & entered(x) & (searched(y,x) -> customofficial(y)))) # label(non_clause).  [assumption].
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
Derived: -vip(c1).  [resolve(8,a,9,a)].
10 -customofficial(x) | -drug_pusher(x).  [deny(4)].
Derived: -customofficial(c1).  [resolve(10,b,9,a)].

Eliminating searched/2
11 vip(c1) | searched(f1(c1),c1).  [resolve(5,a,7,a)].
12 -searched(x,c1) | customofficial(x).  [clausify(2)].
Derived: vip(c1) | customofficial(f1(c1)).  [resolve(11,b,12,a)].

Eliminating vip/1
13 -vip(c1).  [resolve(8,a,9,a)].
14 vip(c1) | customofficial(f1(c1)).  [resolve(5,a,6,a)].
Derived: customofficial(f1(c1)).  [resolve(13,a,14,a)].
15 vip(c1) | customofficial(f1(c1)).  [resolve(11,b,12,a)].

Eliminating customofficial/1
16 customofficial(f1(c1)).  [resolve(13,a,14,a)].
17 -customofficial(c1).  [resolve(10,b,9,a)].

============================== end predicate elimination =============

Auto_denials:  (no changes).

Term ordering decisions:
Predicate symbol precedence:  predicate_order([ ]).
Function symbol precedence:  function_order([ ]).
After inverse_order:  (no changes).
Unfolding symbols: (none).

Auto_inference settings:
  % set(neg_binary_resolution).  % (HNE depth_diff=0)
  % clear(ordered_res).  % (HNE depth_diff=0)
  % set(ur_resolution).  % (HNE depth_diff=0)
    % set(ur_resolution) -> set(pos_ur_resolution).
    % set(ur_resolution) -> set(neg_ur_resolution).

Auto_process settings:  (no changes).


============================== end of process initial clauses ========

============================== CLAUSES FOR SEARCH ====================

% Clauses after input processing:

formulas(usable).
end_of_list.

formulas(sos).
end_of_list.

formulas(demodulators).
end_of_list.

============================== end of clauses for search =============

============================== SEARCH ================================

% Starting search at 0.00 seconds.

============================== STATISTICS ============================

Given=0. Generated=0. Kept=0. proofs=0.
Usable=0. Sos=0. Demods=0. Limbo=0, Disabled=13. Hints=0.
Kept_by_rule=0, Deleted_by_rule=0.
Forward_subsumed=0. Back_subsumed=0.
Sos_limit_deleted=0. Sos_displaced=0. Sos_removed=0.
New_demodulators=0 (0 lex), Back_demodulated=0. Back_unit_deleted=0.
Demod_attempts=0. Demod_rewrites=0.
Res_instance_prunes=0. Para_instance_prunes=0. Basic_paramod_prunes=0.
Nonunit_fsub_feature_tests=0. Nonunit_bsub_feature_tests=0.
Megabytes=0.03.
User_CPU=0.00, System_CPU=0.02, Wall_clock=0.

============================== end of statistics =====================

============================== end of search =========================

SEARCH FAILED

Exiting with failure.

Process 5506 exit (sos_empty) Sun Mar  5 23:32:33 2023
---

## 3. Puzzle C
1. all x all y (Pizza(y) & Eats(x,y) -> Happy(x)).
2. all x exists y (Foodie(x) -> (Pizza(y) | Salad(y)) & Eats(x,y)).
3. all x all y (Salad(y) & Eats(x,y) -> Healthy(x)).
4. all x (Healthy(x) -> Gyms(x)).
5. all x all y (Nice(x) -> Happy(y) & -Dated(x,y)).
6. Nice(Ann) & Foodie(Peter).
7. (Conclusion) Gyms(Peter) -> -Dated(Ann, Peter).

### Input
---
formulas(sos).
  all x all y (Pizza(y) & Eats(x,y) -> Happy(x)).
  all x exists y (Foodie(x) -> (Pizza(y) | Salad(y)) & Eats(x,y)).
  all x all y (Salad(y) & Eats(x,y) -> Healthy(x)).
  all x (Healthy(x) -> Gyms(x)).
  all x all y (Nice(x) -> Happy(y) & -Dated(x,y)).
  Nice(Ann) & Foodie(Peter).
end_of_list.

formulas(goals).
  Gyms(Peter) -> -Dated(Ann, Peter).
end_of_list.
---

### Output
---
============================== Prover9 ===============================
Prover9 (64) version 2009-11A, November 2009.
Process 5480 was started by Christian on DESKTOP-U2JP5RS,
Sun Mar  5 23:31:08 2023
The command was "prover9 -f puzzleC.in".
============================== end of head ===========================

============================== INPUT =================================

% Reading from file puzzleC.in


formulas(sos).
(all x all y (Pizza(y) & Eats(x,y) -> Happy(x))).
(all x exists y (Foodie(x) -> (Pizza(y) | Salad(y)) & Eats(x,y))).
(all x all y (Salad(y) & Eats(x,y) -> Healthy(x))).
(all x (Healthy(x) -> Gyms(x))).
(all x all y (Nice(x) -> Happy(y) & -Dated(x,y))).
Nice(Ann) & Foodie(Peter).
end_of_list.

formulas(goals).
Gyms(Peter) -> -Dated(Ann,Peter).
end_of_list.

============================== end of input ==========================

============================== PROCESS NON-CLAUSAL FORMULAS ==========

% Formulas that are not ordinary clauses:
1 (all x all y (Pizza(y) & Eats(x,y) -> Happy(x))) # label(non_clause).  [assumption].
2 (all x exists y (Foodie(x) -> (Pizza(y) | Salad(y)) & Eats(x,y))) # label(non_clause).  [assumption].
3 (all x all y (Salad(y) & Eats(x,y) -> Healthy(x))) # label(non_clause).  [assumption].
4 (all x (Healthy(x) -> Gyms(x))) # label(non_clause).  [assumption].
5 (all x all y (Nice(x) -> Happy(y) & -Dated(x,y))) # label(non_clause).  [assumption].
6 Nice(Ann) & Foodie(Peter) # label(non_clause).  [assumption].
7 Gyms(Peter) -> -Dated(Ann,Peter) # label(non_clause) # label(goal).  [goal].

============================== end of process non-clausal formulas ===

============================== PROCESS INITIAL CLAUSES ===============

% Clauses before input processing:

formulas(usable).
end_of_list.

formulas(sos).
-Pizza(x) | -Eats(y,x) | Happy(y).  [clausify(1)].
-Foodie(x) | Pizza(f1(x)) | Salad(f1(x)).  [clausify(2)].
-Foodie(x) | Eats(x,f1(x)).  [clausify(2)].
-Salad(x) | -Eats(y,x) | Healthy(y).  [clausify(3)].
-Healthy(x) | Gyms(x).  [clausify(4)].
-Nice(x) | Happy(y).  [clausify(5)].
-Nice(x) | -Dated(x,y).  [clausify(5)].
Nice(Ann).  [clausify(6)].
Foodie(Peter).  [clausify(6)].
Gyms(Peter).  [deny(7)].
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
18 -Nice(x) | Happy(y).  [clausify(5)].
19 -Nice(x) | -Dated(x,y).  [clausify(5)].
Derived: Happy(x).  [resolve(17,a,18,a)].
Derived: -Dated(Ann,x).  [resolve(17,a,19,a)].

Eliminating Gyms/1

Eliminating Dated/2
20 -Dated(Ann,x).  [resolve(17,a,19,a)].
21 Dated(Ann,Peter).  [deny(7)].
Derived: $F.  [resolve(20,a,21,a)].

Eliminating Eats/2

Eliminating Happy/1

============================== end predicate elimination =============

Auto_denials:  (no changes).

Term ordering decisions:
Predicate symbol precedence:  predicate_order([ ]).
Function symbol precedence:  function_order([ ]).
After inverse_order:  (no changes).
Unfolding symbols: (none).

Auto_inference settings:
  % set(neg_binary_resolution).  % (HNE depth_diff=0)
  % clear(ordered_res).  % (HNE depth_diff=0)
  % set(ur_resolution).  % (HNE depth_diff=0)
    % set(ur_resolution) -> set(pos_ur_resolution).
    % set(ur_resolution) -> set(neg_ur_resolution).

Auto_process settings:  (no changes).


============================== PROOF =================================

% Proof 1 at 0.00 (+ 0.02) seconds.
% Length of proof is 8.
% Level of proof is 3.
% Maximum clause weight is 0.000.
% Given clauses 0.

5 (all x all y (Nice(x) -> Happy(y) & -Dated(x,y))) # label(non_clause).  [assumption].
6 Nice(Ann) & Foodie(Peter) # label(non_clause).  [assumption].
7 Gyms(Peter) -> -Dated(Ann,Peter) # label(non_clause) # label(goal).  [goal].
17 Nice(Ann).  [clausify(6)].
19 -Nice(x) | -Dated(x,y).  [clausify(5)].
20 -Dated(Ann,x).  [resolve(17,a,19,a)].
21 Dated(Ann,Peter).  [deny(7)].
22 $F.  [resolve(20,a,21,a)].

============================== end of proof ==========================

============================== STATISTICS ============================

Given=0. Generated=1. Kept=0. proofs=1.
Usable=0. Sos=0. Demods=0. Limbo=0, Disabled=19. Hints=0.
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

Process 5480 exit (max_proofs) Sun Mar  5 23:31:08 2023
---