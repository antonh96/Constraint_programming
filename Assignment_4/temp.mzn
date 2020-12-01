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
array[1..length(add)] of var 0..100: starts_add;
array[1..length(mul)] of var 0..100: starts_mul;

array[1..n] of var int : starts;

array[1..n] of var int : durations;

constraint forall(i in 1..length(add))(
  (durations[add[i]] = del_add) /\ (starts[add[i]] = starts_add[i])
  );
  
constraint forall(i in 1..length(mul))(
  durations[mul[i]] = del_mul /\ starts[mul[i]] = starts_mul[i]
  );

%t2 can not start before t1 is finished
constraint forall(node in add++mul, dep in dependencies[node])(
  starts[dep] + durations[dep] <= starts[node]
  );

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

var int: endtime = max([starts[i]+durations[i]| i in last]);

solve minimize max(starts);

output ["endtime", show(endtime), "start", show(starts)];
