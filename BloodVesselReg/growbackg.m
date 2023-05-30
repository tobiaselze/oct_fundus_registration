% Function that grows background class, with gradient restriction.
% Input:maxima curvature (e2), gradient (G),
% matrix of seeds (c), mean (m) and std (s) of
% classes, number of neighbours (M), and parameters for
% interval sizes of: gradient=ag, and curvature=av
% Ouput: c, pixles classified in this iteration
% where c==1:vessels class, c==-1: background class and c==0:unknown
%
% Function written by M. Elena Martinez-Perez, (1999)
% National Autonomous University of Mexico, UNAM
%
% c=growbackg(e2,G,c,m,s,M,a);
%
%

function [c,it]=growbackg(e2,G,c,m,s,M,a);
it=0;
hf=1;
class=[-1 1];  % background=-1, vassel=1

% Mask for the counting of neighbourhood
mask=[1 1 1
      1 0 1
      1 1 1];

mask=double(mask);

while(hf~=0)

    inf=m(2)-a*s(2);
    sup=m(2)+a*s(2); 
    mmg=m(1)+s(1);

    c1=c==class(1); 
    c1=double(c1);
    n1=conv2(c1,mask,'same');  % neighbours already classified
    
    c2=( (inf<=e2) & (e2<=sup) & (G<=mmg) );  % condition 
    
    k=find( c==0 & c2 & n1>=M);
  
    hf=length(k);

    c(k)=ones(size(k)).*class(1);

    it=it+1;
end;










