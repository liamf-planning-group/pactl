# PACTL - planner based on alpha-CTL


References: [Planejamento sob incerteza para metas de alcançabilidade estendidas](http://www.teses.usp.br/teses/disponiveis/45/45134/tde-09042008-105750/pt-br.php) (Pereira, Silvio do Lago - 2007)

## Run tests:

 * swipl pactl.pl test1.pl
 * swipl pactl.pl test2.pl


**Given the initial state s0 and the goal g:**
 * weak policy: pactl(s0, ef(g)).
 * strong policy: pactl(s0, af(g)).
 * strong cycling  policy: pactl(s0, ag(ef(g))).
