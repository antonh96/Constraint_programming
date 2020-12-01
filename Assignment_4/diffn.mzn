include "globals.mzn";

% Use this editor as a MiniZinc scratch book
int : del_add;
int : del_mul;

int: number_add;
int : number_mul;

%number of operations
int : n;

set of int : last;
set of int : add;
set of int : mul;

array[1..n] of set of int : dependencies;

%start times
array[1..length(add)] of var 1..100: starts_add;
array[1..length(mul)] of var 1..100: starts_mul;

array[1..n, 1..4] of var 1..n : tasks;

var 1..2 : processor;


%t2 can not start before t1 is finished
constraint forall(node in add, dep in dependencies[node])( if exists(d in starts_add)(d = dep) then (starts_add[node] + del_add <= starts_add[dep]) else (starts_add[node] + del_add <= starts_mul[dep]) endif);

constraint forall(node in mul, dep in dependencies[node+length(add)])(if exists(d in starts_mul)(d = dep) then (starts_mul[node] + del_mul <= starts_mul[dep]) else (starts_mul[node] + del_mul <= starts_add[dep]) endif);

%lists for diffn with adders
array[1..length(add)] of var 1..number_add : list_adders;
array[1..length(add)] of var int : list_dur = [del_add | i in 1..length(add)];
array[1..length(add)] of int : list_1 = [1 | i in 1..length(add)];

%lists for diffn with mullers
array[1..length(mul)] of var 1..number_mul : list_mullers;
array[1..length(mul)] of var int : list_dur_mul = [del_mul | i in 1..length(mul)];
array[1..length(mul)] of int : list_2 = [1 | i in 1..length(mul)];

%constraints
constraint diffn(starts_add, list_adders, list_dur, list_1);
constraint diffn(starts_mul, list_mullers, list_dur_mul, list_2);

constraint cumulative(starts_add, list_dur, list_1, number_add);
constraint cumulative(starts_mul, list_dur_mul, list_2, number_mul);

solve satisfy;
