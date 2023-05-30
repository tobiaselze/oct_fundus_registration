% Function that computes the statistics of each class
% m=[mg mf mv] (means), s=[sg sf sv] (standard deviation)
% of classes: low gradient, background and vessel.
% Plant seeds of each class in c.
% It also return e2 and G rescale on (1-256) gray scales. 
% The input are the maximum over scales
% of the maxima principal curvature (e2), the maximum
% over scales of the gradient magnitude (G), and a flag
% which inidicates flag=1 red-free, or flag=0 fluorescein
%
% Function written by M. Elena Martinez-Perez, (1999)
% National Autonomous University of Mexico, UNAM
%
%        [c,m,s,e2,G]=plant_seeds(e2,G,flag)

function [c,m,s,e2,G]=plant_seeds(e2,G,flag)

disp('Planting seeds... ');

% c= matrix of classes: 
% -1 = Background, 1 = Vessel, 0 = Unknown
c=zeros(size(e2));

% Intensity rescaling (0-1)
if flag==1
  % for red-free
  e2=e2./min(e2(:));
  G=G./max(G(:));
else
  % for fluorescein
  e2=e2./max(e2(:));;
  G=G./max(G(:));
end;

% rescale from 1-256
e2=rescale255(e2);
G=rescale255(G);


% Compute the histogram of e2
h=hist(e2(:),256);

% Compute the histogram of G
hg=hist(G(:),256);

% Compute threshold for G using otsu algorithm
tg=otsu(hg);

% Statistics for low gradient class
[mg,sg]=lmshisto2(hg(1:tg),50);

% Compute threshold for e2 using otsu algorithm
t=otsu(h);   

% Statistics for background class
[mf,sf]=class_stat(h,1,t);

% Statistics for vessel class 
[mv,sv]=class_stat(h,t,256);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       PLANTING SEEDS

% vessel seeds with very high probability
j=find( e2 > mv );
c(j)=ones(size(j));

% background seeds with very high probability
k=find( e2 < mf );
c(k)=-ones(size(k));

% classes:
m=[mg mf mv];
s=[sg sf sv];











