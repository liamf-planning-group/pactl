/*------------------------------------------------------------------+
| PACTL - planejador baseado em verificacao de modelos com alfa-CTL |
+------------------------------------------------------------------*/

pactl(So,G) :-
	modelo(min,G,M),
	cobertura(M,C),
	(member(So,C)
	-> (politica([So],M,[],P),
		format('\nPolitica:\n'),
		exibe(P))
		;
		format('fracasso')).

% proposicoes atomicas

modelo(_,F,M) :-
	atomic(F),
	set(S,sat(S,F),M).

% operadores proposicionais

modelo(E,not(F),M) :- !,
	atomic(F),
	modelo(min,true,M1),
	modelo(E,F,M2),
	subtract(M1,M2,M).

modelo(E,and(F1,F2),M) :-
	modelo(E,F1,M1),
	modelo(E,F2,M2),
	intersection(M1,M2,M).

modelo(E,or(F1,F2),M) :- !,
	modelo(E,F1,M1),
	modelo(E,F2,M2),
	union(M1,M2,M).

% operadores temporais locais

modelo(E,ex(F1),M) :- !,
	modelo(E,F1,M1),
	cobertura(M1,C1),
	preImagemFraca(C1,I),
	podaX(I,C1,I1),
	union(M1,I1,M).

modelo(E,ax(F1),M) :- !,
	modelo(E,F1,M1),
	cobertura(M1,C1),
	preImagemForte(C1,I),
	podaX(I,C1,I1),
	union(M1,I1,M).

% operadores temporais globais

modelo(_,eg(F1),M) :- !,
	modelo(max,F1,M1),
	pfmaxEG(nil,M1,M).

modelo(_,ag(F1),M) :- !,
	modelo(max,F1,M1),
	pfmaxAG(nil,M1,M).

modelo(E,eu(F1,F2),M) :- !,
	modelo(min,F1,M1),
	modelo(min,F2,M2),
	cobertura(M1,C1),
	pfminEU(E,C1,nil,M2,M).

modelo(E,au(F1,F2),M) :- !,
	modelo(min,F1,M1),
	modelo(min,F2,M2),
	cobertura(M1,C1),
	pfminAU(E,C1,nil,M2,M).

modelo(E,ef(F1),M) :- !,
	modelo(E,eu(true,F1),M).

modelo(E,af(F1),M) :- !,
	modelo(E,au(true,F1),M).

% ponto-fixo maximo

pfmaxEG(M,M,M) :- !.
pfmaxEG(_,M1,M) :-
	cobertura(M1,C1),
	preImagemFraca(C1,I),
	podaG(I,M1,I1),
	pfmaxEG(M1,I1,M).

pfmaxAG(M,M,M) :- !.
pfmaxAG(_,M1,M) :-
	cobertura(M1,C1),
	preImagemForte(C1,I),
	podaG(I,C1,I1),
	pfmaxAG(M1,I1,M).

% ponto-fixo minimo

pfminEU(_,_,M,M,M) :- !.
pfminEU(E,C1,_,M2,M) :-
	cobertura(M2,C2),
	preImagemFraca(C2,I),
	podaU(E,I,C1,C2,I1),
	union(I1,M2,M3),
	pfminEU(E,C1,M2,M3,M).

pfminAU(_,_,M,M,M) :- !.
pfminAU(E,C1,_,M2,M) :-
	cobertura(M2,C2),
	preImagemForte(C2,I),
	podaU(E,I,C1,C2,I1),
	union(I1,M2,M3),
	pfminAU(E,C1,M2,M3,M).


% funcoes de pre-imagem

preImagemFraca(C,I) :-
	set((S,A),T^(trans(S,A,T),not(intersection(T,C,[]))),I).

preImagemForte(C,I) :-
	set((S,A),T^(trans(S,A,T),subset(T,C)),I).

% funcoes de poda de pre-imagem

podaX(I,M,I1) :-
	set((S,A),(member((S,A),I),not(member(S,M))),I1).

podaG(I,C,I1) :-
	set((S,A),(member((S,A),I),member(S,C)),I1).

podaU(E,I,C1,C2,I2) :-
	set((S,A),(member((S,A),I),member(S,C1)),I1),
	(E=min
	-> set((S,A),(member((S,A),I1),not(member(S,C2))),I2)
	; I1=I2).

% predicados auxiliares

cobertura(M,C) :-
	set(S,A^member((S,A),M),N),
	set(S,(member(S,M),atomic(S)),T),
	union(N,T,C).


politica([],_,P1,P2) :- sort(P1,P2).
politica([S|Ss],M,P1,P2) :-
	not(member((S,_),P1))
	-> (member((S,A),M)
		-> (trans(S,A,T),
			append(Ss,T,ST),
			politica(ST,M,[(S,A)|P1],P2))
		; politica(Ss,M,[(S,tau)|P1],P2))
	; politica(Ss,M,P1,P2).


exibe([]) :- nl.
exibe([P|Ps]) :-
	((P=(S,A), A\=tau) -> format('\n(~w,~w)',[S,A]) ; true),
	exibe(Ps).

set(X,C,S) :-
	(setof(X,C,R)
	-> sort(R,S)
	; S=[]).

sat(S,P) :-
	label(S,L),
	memberchk(P,[true|L]).
