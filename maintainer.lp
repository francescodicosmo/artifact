
% For local predicates the first component is the local node.
% For local transport predicates, the last component is the address (sender or receiver).
% The special message start (chStart) contains only the node name of its self-loop.
% For on channel transport predicates (the prefix is ch) the first two components are the channel sender and recipient and the last one is the message multiplicity.
#program always.

%
% Global and local network representation, based on network.lp.
ch(X,X) :- node(X).
ch(X,Y) :- channel(X,Y).
ch(X,Y) :- channel(Y,X).
myName(N,N) :- node(N).
myNeigh(N,M) :- ch(N,M), node(N), N!=M.
myExtNeigh(N,M) :- node(M), node(N).

#program initial.

% Initialize channels.
chStart(N) :- node(N).

#program dynamic.

% deliver only one message, if possible, or terminate (suppose transport signature T=<leader/1>).
deliverable :- N=#count{rLeader(Y,C,X) : 'chLeader(X,Y,C,_); rStart(X) : 'chStart(X)}, N>0. % Transport signature dependent
termination :- not deliverable.
termination :- 'termination.
{rLeader(Y,C,X) : 'chLeader(X,Y,C,_); rStart(X) : 'chStart(X)}=1 :- deliverable. % Transport signature dependent

actNode(Y) :- rStart(Y).
actNode(Y) :- rLeader(Y,C,X). % Transport signature dependent

% Update channel content
chStart(X) :- 'chStart(X), not rStart(X).

rChLeader(Y,X,C,N) :- 'chLeader(Y,X,C,N), not rLeader(X,C,Y). % Transport signature dependent
rChLeader(Y,X,C,N-1) :- 'chLeader(Y,X,C,N), N>1, rLeader(X,C,Y). % Transport signature dependent

someChLeader(X,Y,C) :- rChLeader(X,Y,C,_). % Transport signature dependent
chLeader(X,Y,C,1) :- sLeader(X,C,Y), not someChLeader(X,Y,C). % Transport signature dependent
chLeader(X,Y,C,N+1) :- sLeader(X,C,Y), rChLeader(X,Y,C,N). % Transport signature dependent
chLeader(X,Y,C,N) :- not sLeader(X,C,Y), rChLeader(X,Y,C,N). % Transport signature dependent

% Maintain inactive node state-DBs.
started(N) :-not actNode(N),'started(N). % State signature dependent
leader(N,X) :-not actNode(N), 'leader(N,X). % State signature dependent
optOut(N) :- not actNode(N), 'optOut(N). % State signature dependent
fixableError(N) :- not actNode(N), 'fixableError(N). % State signature dependent
fixed(N) :- not actNode(N), 'fixed(N). % State signature dependent
trueError(N) :- not actNode(N), 'trueError(N). % State signature dependent
error(N) :- not actNode(N), 'error(N). % State signature dependent
