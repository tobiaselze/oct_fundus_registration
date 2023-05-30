% Function that calculates the mean of and array a
% or a class, m=mean in the range [k1,k2]
% m = sigma (prob*i)
%
% Function written by M. Elena Martinez-Perez, (1999)
% National Autonomous University of Mexico, UNAM

%
%  m = class_mean(a,k1,k2)
%

function m = class_mean(a,k1,k2)

m=0;
sigma=0;

sigma=sum(a(k1:k2));

if sigma==0
   prob=0;
else
   prob=a(k1:k2)./sigma;
end

ind = k1:k2;

m=sum(prob.*ind);







