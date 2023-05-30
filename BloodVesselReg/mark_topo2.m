function skd=mark_topo2(sk);
% Function that marks the significant points
% in the skeletons. -101 = terminal and
% -3=candidates of bifurcation points.
% Input: the binary skeleton, output: the skeleton marked
%
% Function written by M. Elena Martinez-Perez, (1999)
% National Autonomous University of Mexico, UNAM
%
%   skd=mark_topo2(sk)
%
skd=double(sk);

% to mark branches
TB=bwmorph(sk,'branchpoints');
b=find(TB==1);
skd(b)=-3;

% to mark terminals
TT=bwmorph(sk,'endpoints');
t=find(TT==1);
skd(t)=-101;

%%%%%%%%%%%%%%%%%%%%%%%%

% para borrar bifurcacion con dos terminales dentro de vecindad 3x3
[row,col]=size(skd); 
[x,y]=find(skd==-3);
r=1;

for i=1:length(y)
    
% To take care of the limits of the image
  dli=0;dhi=0;
  dlj=0;dhj=0;
  LI=x(i)-r; HI=x(i)+r;
  LJ=y(i)-r; HJ=y(i)+r;
  if (LI<1)   dli=abs(LI)+1; LI=LI+dli; end;
  if (HI>row) dhi=HI-row;    HI=HI-dhi; end;
  if (LJ<1)   dlj=abs(LJ)+1; LJ=LJ+dlj; end;
  if (HJ>col) dhj=HJ-col;    HJ=HJ-dhj; end;
  
   % define the ROI
  aux=skd(LI:HI,LJ:HJ);
  e=find(aux==-101);

  if ~isempty(e)
      aux(e(1))=0; % el primer -101 que se encuentra
      aux(5)=1;   % pixel central en 3x3 vecindad
      skd(LI:HI,LJ:HJ)=aux;   
  end
  
  s=sum(aux(:));
  if s==1   % 4 -3 = 1;
      aux(5)=-100;   % pixel central igual a cruce -100
  end
 
  skd(LI:HI,LJ:HJ)=aux;

end

%%%%%%%%%%%%%%%%%%%%%

end

