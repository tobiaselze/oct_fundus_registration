% Function that calculates the mean and standard deviation
% of an array a, or class, m=mean, s=std in the range [k1,k2]
% m = sigma (prob*i)
%
% Function written by M. Elena Martinez-Perez, (1999)
% National Autonomous University of Mexico, UNAM
%
% [m,s] = class_stat(a,k1,k2)
%

function [m,s] = class_stat(a,k1,k2)

m=0;
sigma=0;

if size(a,1)~=1
  a=a';
end;

sigma=sum(a(k1:k2));

if sigma==0
   prob=0;
else
   prob=a(k1:k2)./sigma;
end

ind = k1:k2;
m=sum(prob.*ind);

s=sqrt(sum((ind-m).^2.*prob));
