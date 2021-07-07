# DDS simulator

The DDS Simulator is a tool to simulate the execution of Declarative Distributed Systems (DDSs). Currently, the system simulates a closed DDS implementing a leader election with failure algorithm over a network provided by the user. 

## Installation

1. Install [telingo](https://github.com/potassco/telingo/);
2. Download the repo.

## Usage

1. Specify the network in the file network.lp using standard Telingo syntax in the scope of a *always* directive: use node(n) to define a node with name n; use channel (n,m) to define a channel from n to m. The system will automatically make the channels symmetric and will add the self-loops. The factory-setting is a ring network of three nodes.

2. Specify the properties you want to analize in the file query.lp using standard Telingo syntax in any scope suits you. The factory-setting asks to display finite runs ending in termination,  with no broken node, and to show the elected leader, if it exists.

3. Launch the system with the following command in the command prompt:

   ```Telingo
   telingo maintainer.lp network.lp program.lp query.lp <n> --imin=<l> 
   ```

   where <n> is the number of finite runs you want to analyze (use 0 to show all runs) and <l> is their length. For example, use

   ```Telingo
   telingo maintainer.lp network.lp program.lp query.lp 0 --imin=9 
   ```

## Output

The command prompt will display a number of runs in Telingo fashion. Consider only the last occurrence of *Solving* and its scope. Each answer is a (self-explanatory) valid finite run. For the example command above: 762 runs of length 9 are displayed; those are the runs reaching termination in 8 transitions; non-terminating and longer runs are not shown; sometimes no leader is elected, sometimes a single node is elected; for each node there is at least one run of length 9 that elects him.
