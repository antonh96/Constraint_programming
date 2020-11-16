include "globals.mzn";

int: graph_size;
int: start;
int: n_dests;
array[1..n_dests] of 1..graph_size: dest;
int: n_edges;
array[1..n_edges] of 1..graph_size: from;
array[1..n_edges] of 1..graph_size: to;
array[1..n_edges] of int: cost;

%var int: totalCost;
%array[var 1..n_edges, 1..2] of var 1..graph_size: result;

%constraint subcircuit(nodes);

%[edges[i,1]=from[i], edges[i,2]=to[i] | i in 1..n_edges];

array[1..2*n_edges] of 0..graph_size: edges_1 = [ if i mod 2 = 0 then to[round(i/2)] else from[round(i/2)] endif | i in 1..2*n_edges];
array[1..2*n_edges] of 0..graph_size: edges_2 = [ if i mod 2 = 0 then from[round(i/2)] else to[round(i/2)] endif | i in 1..2*n_edges];
array[1..2*n_edges, 1..2] of 0..graph_size: edges = array2d(1..2*n_edges, 1..2, edges_1++edges_2);

% constraint forall(i in 1..n_edges) ( edges[i,1]=from[i] );
% constraint forall(i in 1..n_edges) ( edges[i,2]=to[i] );
% constraint forall(i in n_edges+1..2*n_edges) ( edges[i,1]=to[i] );
% constraint forall(i in n_edges+1..2*n_edges) ( edges[i,2]=from[i] );

array[1..2*n_edges] of int: costs=cost++cost;

var 0..1000: total_cost;
array[1..2*n_edges] of var 0..1000000: out_flow;
%array[1..grap_size] of int: balance = [if i=start then j=length(dest)| i in 1..graph_size];
constraint network_flow_cost(edges, [1, 0,0,0,0,-1], costs, out_flow, total_cost);

solve minimize total_cost;

%output[show(edges)];
