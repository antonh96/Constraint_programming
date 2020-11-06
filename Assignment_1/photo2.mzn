include "globals.mzn";
int: n;
int: n_prefs;
array[1..n_prefs, 1..2] of 1..n: prefs;

array[1..n] of var 1..n: queue;
array[1..n_prefs] of var 0..n: dist;

%Uniqe persons at each index
constraint alldifferent(queue);

%Counts the distance between people
constraint forall(i in 1..n_prefs)(
    dist[i] = abs(queue[prefs[i,1]]- queue[prefs[i,2]])
  );

%Minimizes the total distance based on the max distance between two persons
solve minimize max(dist);
output["Total cost: " ++ show(max(dist)) ++ ", Queue: " ++ show(queue)]