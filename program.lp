#program initial.

%initial state-DB
fixableError(N):- node(N).

#program dynamic.

%% The flag actNode is necessary to activate only the correct node.
%% To simplify the implementation of a compiler from D2C to Teligo, the special variable Me denotes the active node.

%%% Leader election with failure
started(Me) :- actNode(Me), not 'started(Me).
started(Me) :- actNode(Me), 'started(Me).

% Decide to be leader or to opt out.
{leader(Me,Me); optOut(Me)}=1 :- actNode(Me), not 'started(Me).
leader(Me,X) :- actNode(Me), 'leader(Me,X).
optOut(Me) :- actNode(Me), 'optOut(Me).

% Send and receive leader-messages.
sLeader(Me,Me,X) :- actNode(Me), myNeigh(Me,X), leader(Me,Me), not 'started(Me).
leader(Me,X) :- actNode(Me), rLeader(Me,X,Y).
sLeader(Me,X,Y) :- actNode(Me), myNeigh(Me,X), rLeader(Me,X,Y), not 'leader(Me,X).

% Handle errors.
fixableError(Me) :- actNode(Me), N=#count{X:leader(Me,X)}, N=0.
trueError(Me) :- actNode(Me), leader(Me,X), leader(Me,Y), X!=Y.
fixed(Me) :- actNode(Me), not fixableError(Me), 'fixableError(Me).
fixed(Me) :- actNode(Me), fixed(Me).
error(Me) :- actNode(Me), fixableError(Me).
error(Me) :- actNode(Me), trueError(Me).
broken(Me) :- trueError(Me).