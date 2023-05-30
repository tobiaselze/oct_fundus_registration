% Function that generates skeleton and border images
% from a segmented image bwI
%
% Function written by M. Elena Martinez-Perez, (1999)
% National Autonomous University of Mexico, UNAM
%
%  [Th,B]=skeleton_border(bwI)
%

function [Th,B]=skeleton_border(bwI)

Th=double(bwmorph(bwI,'thin',Inf));
Th=double(bwmorph(Th,'fill'));
Th=double(bwmorph(Th,'thin',Inf));
B=double(bwmorph(bwI,'remove'));
