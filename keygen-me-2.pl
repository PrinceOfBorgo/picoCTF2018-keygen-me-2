:- use_module(library(clpfd)).

% Generate a valid key.
generate(Key) :-
    length(L,16), L ins 0..35,
    constrain(L),
    label(L),
    maplist(num2char, L, M),
    atomics_to_string(M, Key).


% Get Nth item of a list.
nth(0, [E|_], E).
nth(N, [_|Xs], E) :-
    N #> 0,
    N #= N1 + 1,
    nth(N1, Xs, E).

% Number to char coding.
num2char(N, C) :-
    N >= 0, N =< 9,
    Code is N+0x30,
    char_code(C, Code).
num2char(N, C) :-
    N >= 10, N =< 35,
    Code is N+0x37,
    char_code(C, Code).


% Setup the constraints used to calidate the key.
constrain(L) :-
    con1(L), con2(L), con3(L), con4(L),
    con5(L), con6(L), con7(L), con8(L),
    con9(L), con10(L), con11(L), con12(L).


% --- Constraints ---
con1(L) :-
    nth(0, L, X0), nth(1, L, X1), 
    (X0+X1) mod 0x24 #= 0xe.

con2(L) :-
    nth(2, L, X2), nth(3, L, X3), 
    (X2+X3) mod 0x24 #= 0x18.

con3(L) :-
    nth(2, L, X2), nth(0, L, X0), 
    (X2-X0) mod 0x24 #= 6.

con4(L) :-
    nth(1, L, X1), nth(3, L, X3), nth(5, L, X5),
    (X1+X3+X5) mod 0x24 #= 4.
      
con5(L) :-
    nth(2, L, X2), nth(4, L, X4), nth(6, L, X6),
    (X2+X4+X6) mod 0x24 #= 0xd.

con6(L) :-
    nth(3, L, X3), nth(4, L, X4), nth(5, L, X5),
    (X3+X4+X5) mod 0x24 #= 0x16.

con7(L) :-
    nth(6, L, X6), nth(8, L, X8), nth(10, L, X10),
    (X6+X8+X10) mod 0x24 #= 0x1f.

con8(L) :-
    nth(1, L, X1), nth(4, L, X4), nth(7, L, X7),
    (X1+X4+X7) mod 0x24 #= 7.

con9(L) :-
    nth(9, L, X9), nth(12, L, X12), nth(15, L, X15),
    (X9+X12+X15) mod 0x24 #= 0x14.

con10(L) :-
    nth(13, L, X13), nth(14, L, X14), nth(15, L, X15),
    (X13+X14+X15) mod 0x24 #= 0xc.

con11(L) :-
    nth(8, L, X8), nth(9, L, X9), nth(10, L, X10),
    (X8+X9+X10) mod 0x24 #= 0x1b.

con12(L) :-
    nth(7, L, X7), nth(12, L, X12), nth(13, L, X13),
    (X7+X12+X13) mod 0x24 #= 0x17.
