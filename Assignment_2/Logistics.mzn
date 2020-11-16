include "globals.mzn";

int: graph_size;
int: start;
int: n_dests;
array[1..n_dests] of 1..graph_size: dest;
int: n_edges;
array[1..n_edges] of 1..graph_size: from;
array[1..n_edges] of 1..graph_size: to;
array[1..n_edges] of int: cost;

array[1..2*n_edges, 1..2] of 0..graph_size: edges = array2d(1..2*n_edges, 1..2, [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);



%var int: totalCost;
%array[var 1..n_edges, 1..2] of var 1..graph_size: result;

%constraint subcircuit(nodes);

%[edges[i,1]=from[i], edges[i,2]=to[i] | i in 1..n_edges];

constraint forall(i in 1..n_edges) ( edges[i,1]=from[i] );
constraint forall(i in 1..n_edges) ( edges[i,2]=to[i] );
constraint forall(i in n_edges+1..2*n_edges) ( edges[i,1]=to[i] );
constraint forall(i in n_edges+1..2*n_edges) ( edges[i,2]=from[i] );

%trace_stdout(edges);
%array[1..2*n_edges, 1..2] of 1..graph_size: edgesres = ;

array[1..2*n_edges] of int: costs=cost++cost;

var int: total_cost;
array[1..2*n_edges] of var int: out_flow;

constraint network_flow_cost(edges, [1, 0,0,0,0,-1], costs, out_flow, total_cost);
    
array[1..2*n_edges] of var 0..1: out_flow_binary;
constraint forall(i in 1..2*n_edges)(if out_flow[i]>0 then out_flow_binary[i]=1 else out_flow_binary[i]=0 endif);

var int: sum_cost = sum(i in 1..2*n_edges)(out_flow_binary[i]*costs[i]);

%trace("Edges: ", edges);
solve minimize sum_cost;

%    edges[i,2]=to[i]
    %[[from[i]]]
output[show(edges)];


%  exists(node in nodes where exists((dest, node) in edges))