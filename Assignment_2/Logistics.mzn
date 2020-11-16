include "globals.mzn";

int: graph_size;
int: start;
int: n_dests;
int: n_edges;
var 0..1000: total_cost;

array[1..n_dests] of 1..graph_size: dest;
array[1..n_edges] of 1..graph_size: from;
array[1..n_edges] of 1..graph_size: to;
array[1..n_edges] of int: cost;

%cost for all undirected edges
array[1..2*n_edges] of int: costs=cost++cost;

%creates undirected edges needed for the method network_flow
array[1..2*n_edges] of 0..graph_size: edges_1 = [ if i mod 2 = 0 then to[round(i/2)] else from[round(i/2)] endif | i in 1..2*n_edges];
array[1..2*n_edges] of 0..graph_size: edges_2 = [ if i mod 2 = 0 then from[round(i/2)] else to[round(i/2)] endif | i in 1..2*n_edges];
array[1..2*n_edges, 1..2] of 0..graph_size: edges = array2d(1..2*n_edges, 1..2, edges_1++edges_2);

%creates the array balance containing values of start and dests
array[1..graph_size] of int: balance = [if i=start then length(dest) elseif exists(d in dest)(i=d) then -1 else 0 endif| i in 1..graph_size];

%flow for each edge
array[1..2*n_edges] of var 0..sum(costs): out_flow;

%constraint for finding paths in the graph
constraint network_flow_cost(edges, balance, costs, out_flow, total_cost);

%code for creating an out_flow without including a used edge multiple times
array[1..2*n_edges] of var 0..1: out_flow_binary;
constraint forall(i in 1..2*n_edges)(if out_flow[i]>0 then out_flow_binary[i]=1 else out_flow_binary[i]=0 endif);
var int: sum_cost = sum(i in 1..2*n_edges)(out_flow_binary[i]*costs[i]);


solve minimize sum_cost;

output["cost = ", show(sum_cost), "\noutflow = ", show(out_flow_binary)];
