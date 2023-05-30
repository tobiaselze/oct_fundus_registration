function t = otsu(a)
% Function that finds the valley  of a vector 
% (bimodal histogram, a using the otsu method, 
% which maximases the difference between class varances. 
% Returns the valley  t which is
% the position in the vector (indice). Threshold gray level.
% Based on:
% Nobuyuki Otsu (1979). "A threshold selection method from gray-level 
% histograms". IEEE Trans. Sys. Man. Cyber. 9 (1): 62–66.
%
% Function written by M. Elena Martinez-Perez, (1999)
% National Autonomous University of Mexico, UNAM
%
% T=OTSU(A)
% 

% Size should be 1xn
v=size(a);
if v(1)~=1 a=a'; end

% Computes the probabilities of the elements of a
sigma=sum(a);
prob=a./sigma;

aux1=0; aux2=0;
w=0;    s=0;
smax=0;

mt=class_mean(a,1,size(a,2));

% Maximize the differences of the variance of a1,a2
for i=1:size(a,2)-1
   w = w+prob(i);

  a1=a(1:i);
  a2=a(i+1:size(a,2));

   if (w>0) & (w<1)
      aux1=(class_mean(a,1,i) - mt )^2;
      aux2=(class_mean(a,i+1,size(a,2)) - mt )^2;
      s = w * aux1 + (1-w ) * aux2;

      if (s > smax)
	smax=s;
	t=i;    % the valley t.
      end
    end
end














