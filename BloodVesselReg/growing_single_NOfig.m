% Function that perform a region growing algorithm 
% for a single image, used in the displaing results mode.
% Two clases: background and vessel.
% It uses the values of the maximum principal curvature (e2)
% the maximum gradient responce (G), the seeds (c), and
% the means (m) and standard deviations (s), of each class.
% The growth is done alternating clases chanching the interval sizes
% of each class based on the values of parameter 'a' fixed in each
% iteration.
% Output is c which contains values: vessels=1, background=-1
% end unknowns=0.
%
% Function written by M. Elena Martinez-Perez, (1999)
% National Autonomous University of Mexico, UNAM
%
% c=growing_single_NOfig(e2,G,c,m,s);
%
%

function c=growing_single_NOfig(e2,G,c,m,s);
ittot=0;
disp('Growing...');

% Number of neighbours (M), and parameters for
% interval sizes of: gradient=ag, and curvature=av
M=1;
ag=1;
av=1;

for i=1:4
    [c,it]=growvessel(e2,G,c,m,s,M,ag,av);
    ittot=ittot+it;
    av=av+0.5;
end;

a=1;
[c,it]=growbackg(e2,G,c,m,s,M,a);
ittot=ittot+it;
ag=1.5;
av=1;

for i=1:4
    [c,it]=growvessel(e2,G,c,m,s,M,ag,av);
    ittot=ittot+it;
    av=av+0.5;
end;


a=1.5;
[c,it]=growbackg(e2,G,c,m,s,M,a);
ittot=ittot+it;
ag=2;
av=1;

for i=1:3
    [c,it]=growvessel(e2,G,c,m,s,M,ag,av);
    ittot=ittot+it;
    av=av+0.5;
end;

a=2;
[c,it]=growbackg(e2,G,c,m,s,M,a);
ittot=ittot+it;
a=1;
for i=1:3
    [c,it]=growboth(e2,G,c,m,s,M,a);
    ittot=ittot+it;
    a=a+0.5;
end;

fprintf('Total number of iterations: %6d \n',ittot);

disp('Growing Completed ');

