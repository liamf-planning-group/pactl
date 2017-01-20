% funcao de rotulacao de estados

label(s0, [ ]).
label(s1, [ ]).
label(s2, [ ]).
label(s3, [ ]).
label(s4, [ ]).
label(s5, [ ]).
label(s6, [ ]).
label(s7, [ ]).
label(s8, [ ]).
label(s9, [g]).
label(s10, [ ]).

% funcao de transicao de estados
trans( s0, a, [s2, s3]).
trans( s0, b, [s1]).
trans( s1, b, [s3]).
trans( s1, c, [s4]).
trans( s2, tau, [s2]).
trans( s3, b, [s6]).
trans( s4, a, [s5, s7]).
trans( s4, b, [s8]).
trans( s5, c, [s3]).
trans( s6, a, [s5, s9]).
trans( s7, tau, [s7]).
trans( s8, b, [s9, s10]).
trans( s8, c, [s5]).
trans( s9, tau, [s9]).
trans( s10, a, [s9]).
trans( s10, c, [s7]).
