% Function that erase spur lines of an specific size.
% The size of the lines to be ereased are calculated
% adaptatively depending on an approximated size of the vessel widths
% bw, is the binary vessels segmented image,
% sk is the clean skeleton
%
% Function written by M. Elena Martinez-Perez, (2010)
% National Autonomous University of Mexico, UNAM
%
% sk=erase_spur_avg_radius2(bw)
%

function sk=erase_spur_avg_radius2(bw)

% Se obtiene el esqueleto
Th=double(bwmorph(bw,'thin',Inf));
Th=double(bwmorph(Th,'fill'));
Th=double(bwmorph(Th,'thin',Inf));
Th=bwmorph(Th,'clean'); % erase isolate pixels

% Se obtiene el area de los vasos
bw_area=sum(bw(:));

% se obtiene el area del esqueleto ~= al tamaño lineal
Th_area=sum(Th(:));

% diametro promedio approximado (2 veces el radio)
d=fix(bw_area/Th_area);
d=d*2;    % Elena 31/05/2020

sk=bwmorph(Th,'spur',d);

% clean the corners that might have the skeleton
% with hit and miss transformation.

% Upper left corner
B1=[0 1 0; 0 1 1; 0 0 0];
B2=[0 0 0; 1 0 0; 1 1 0];
c1=bwhitmiss(sk,B1,B2);
k1=find(c1==1);
sk(k1)=0;

% Down left corner
B1=[0 0 0; 0 1 1; 0 1 0];
B2=[1 1 0; 1 0 0; 0 0 0];
c2=bwhitmiss(sk,B1,B2);
k2=find(c2==1);
sk(k2)=0;

% Upper right corner
B1=[0 0 0; 1 1 0; 0 1 0];
B2=[0 1 1; 0 0 1; 0 0 0];
c3=bwhitmiss(sk,B1,B2);
k3=find(c3==1);
sk(k3)=0;

% Down right corner
B1=[0 1 0; 1 1 0; 0 0 0];
B2=[0 0 0; 0 0 1; 0 1 1];
c4=bwhitmiss(sk,B1,B2);
k4=find(c4==1);
sk(k4)=0;

end


