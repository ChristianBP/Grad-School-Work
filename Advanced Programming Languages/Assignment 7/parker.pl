/* CS6371: Assignment 7

    Name: Christian Parker
    Email: cxp220034@utdallas.edu

*/

lplus(0,Y,Y).
lplus(s(X),Y,s(Z)) :- lplus(X,Y,Z).
ltimes(0, _ ,0).
ltimes(s(X),Y,Z) :- ltimes(X,Y,XY), lplus(XY,Y,Z).


/* Question 1 */
/* a */
fibonacci(0, 0).
fibonacci(s(0), s(0)).
fibonacci(s(s(X)), Y) :-
    fibonacci(X, A),
    fibonacci(s(X), B),
    lplus(A, B, Y).

/* b */
factorial(0, s(0)).
factorial(s(X), Y) :-
    factorial(X, Z),
    ltimes(Z, s(X), Y).

/* c */
listsum(s(0), [s(0)]).
listsum(s(N), [s(0) | T]) :- listsum(N, T).
listsum(s(N), [s(H) | T]) :- listsum(N, [H | T]).


/* Question 2 */
contains(X, [X|_]).
contains(X, [_|T]) :- contains(X, T).

remove(_, [], []).
remove(X, [X|T], L) :- remove(X, T, L).
remove(X, [H|T], [H|L]) :- X \= H, remove(X, T, L).

/* a */
union(S1, [], S1).
union(S1, [H|T], Out) :-
    contains(H, S1),
    union(S1, T, Out).
union(S1, [H|T], [H|Out]) :-
    \+ contains(H, S1),
    union(S1, T, Out).

/* b */
intersection(_, [], []).
intersection(S1, [H|T], [H|Out]) :-
    contains(H, S1),
    intersection(S1, T, Out).
intersection(S1, [H|T], Out) :-
    \+ contains(H, S1),
    intersection(S1, T, Out).

/* c */
setdiff(S1, [], S1).
setdiff(S1, [H|T], Out) :-
    contains(H, S1),
    remove(H, S1, NewS1),
    setdiff(NewS1, T, Out).
setdiff(S1, [H|T], [H|Out]) :-
    \+ contains(H, S1),
    setdiff(S1, T, Out).

/* d */
subset([], _).
subset([H|T], S2) :-
    contains(H, S2),
    subset(T, S2).


/* Question 3 */
/* a */
cas(var(X), E, X, E).
cas(var(Y), _, X, var(Y)) :- X \= Y.
cas(lam(X, E), _, X, lam(X, E)).
cas(lam(Y, E0), E, X, lam(Y, E3)) :-
    X \= Y,
    cas(E0, E, X, E3).
cas(app(E1, E2), E, X, app(E3, E4)) :-
    cas(E1, E, X, E3),
    cas(E2, E, X, E4).

/* b */
eval(lam(V,E), lam(V,E)).
eval(app(E1,E2), EP) :-
    eval(E1, lam(V, E)),
    cas(E, E2, V, EE),
    eval(EE, EP).
