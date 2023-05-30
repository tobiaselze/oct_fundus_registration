% Function that grows both classes alternatively, 
% without the gradient restriction.
% Input:maxima curvature (e2), gradient (G),
% matrix of seeds (c), maen (m) and std (s) of
% classes, number of neighbours (M), and parameters for
% interval sizes for both classse the same 'a'
% Ouput: c, pixles classified in this iteration
% where c==1:vessels class, c==-1: background class and c==0:unknown
%
% Function written by M. Elena Martinez-Perez, (1999)
% National Autonomous University of Mexico, UNAM
%
% c=growboth(e2,G,c,m,s,M,a);
%
%

function [c,it]=growboth(e2,G,c,m,s,M,a);
it=0;
hc=[1 1];
class=[-1 1];  % background=-1, vessel=1

% Mask for the neighbourhood
mask=[1 1 1
      1 0 1
      1 1 1];
mask=double(mask);

while(any(hc~=0))

  for i=1:length(class)
 
    inf=m(i+1)-a*s(i+1);
    sup=m(i+1)+a*s(i+1);

    c1=c==class(i); 
    c1=double(c1);
    n1=conv2(c1,mask,'same');  % neighbours already classified
    
    c2=( (inf<=e2) & (e2<=sup) );  % condition 

    k=find( c==0 & c2 & n1>=M );
  
    hc(i)=length(k);

    c(k)=ones(size(k)).*class(i);
    it=it+1;
  end;
  
end;










