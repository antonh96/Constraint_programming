include "globals.mzn";

int: n;
int: n_prefs;
array[1..n_prefs, 1..2] of 1..n: prefs;

array[1..n] of var 1..n: queue;
array[1..n_prefs] of var 0..1: satisfied;
var 0..n_prefs: nbr_satisfied;

%Uniqe persons at each index
constraint alldifferent(queue);

%Gives a value of 1 or 0 in the array satisfied based on preferences and placement
constraint forall(i in 1..n_prefs)(
    (abs(queue[prefs[i,1]]- queue[prefs[i,2]])=1) = satisfied[i]
  );
%Counts the number of people that are satisified with the placement
constraint nbr_satisfied=sum(satisfied);

solve maximize nbr_satisfied;