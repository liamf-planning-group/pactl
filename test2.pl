% funcao de rotulacao de estados

label(s0, [r]).
label(s1, [ ]).
label(s2, [r]).
label(s3, [ ]).
label(s4, [ ]).
label(s5, [g]).
label(s6, [ ]).

% funcao de transicao de estados
trans( s0, a, [s1]).
trans( s0, b, [s3]).
trans( s1, c, [s4]).
trans( s1, b, [s2]).
trans( s2, tau, [s2]).
trans( s3, c, [s6]).
trans( s4, a, [s5]).
trans( s5, tau, [s5]).
trans( s6, a, [s2]).
trans( s6, b, [s5]).
