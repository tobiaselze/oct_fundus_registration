% Function that grows vessel class, with gradient restriction.
% Input:maxima curvature (e2), gradient (G),
% matrix of seeds (c), maen (m) and std (s) of
% classes, number of neighbours (M), and parameters for
% interval sizes of: gradient=ag, and curvature=av
% Ouput: c, pixles classified in this iteration
% where c==1:vessels class, c==-1: background class and c==0:unknown
%
% Function written by M. Elena Martinez-Perez, (1999)
% National Autonomous University of Mexico, UNAM
%
% c=growvessel(e2,G,c,m,s,M,ag,av);
%
%

function [c,it]=growvessel(e2,G,c,m,s,M,ag,av);
it=0;
hv=1;
class=[-1 1];  % background=-1, vassel=1

% Mask for counting the neighbourhood
mask=[1 1 1
      1 0 1
      1 1 1];
mask=double(mask);

while(hv~=0)

    inf=m(3)-av*s(3);  % inferior limit of the interval for e2
    sup=m(3)+av*s(3);  % superior limit of the interval for e2
    supg=(m(1)+ag*s(1));  % thrshold for the gradient   

    c1=c==class(2); 
    c1=double(c1);
    n1=conv2(c1,mask,'same');  % neighbours already classified
   
    c2=( (inf<=e2) & (G<=supg) );  % condition of growing 

    k=find( c==0 & c2 & n1>=M);
 
    hv=length(k);

    c(k)=ones(size(k));
    it=it+1;
end;










