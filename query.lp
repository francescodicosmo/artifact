#program final.
:- not termination.
:- broken(N), node(N).
elected(M) :- leader(N,M).
elected :- elected(M).
noneElected :- not elected.

%#program always.
#show elected/1.
#show noneElected/0.
#show broken/1.