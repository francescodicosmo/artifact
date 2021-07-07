% Specify node names in relation node/1.
% Specify undirected channels in relation channel/2.
% Self-loop are added automatically, if not given.
#program always.

% Ring with 2 nodes.
#const n=1.
node(0..n).
channel(n,0).
channel(N,N+1) :- node(N), node(N+1).