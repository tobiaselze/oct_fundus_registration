function y=rescale255(x);
%
% Function written by M. Elena Martinez-Perez, (1999)
% National Autonomous University of Mexico, UNAM
%
range=max(max(x))-min(min(x));

y=255*(x-min(min(x)))/range;