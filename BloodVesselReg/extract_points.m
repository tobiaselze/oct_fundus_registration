function [pts,pts2,sk_label] = extract_points(bw)

% Extract the skeleton points coordenates
% 
% bw  - Segmented Vessel binary image
% pts, pts2 - characteristic points [x y]
% sk_label  - skeleton image
%  
% Function written by M. Elena Martinez-Perez, (2010)
% National Autonomous University of Mexico, UNAM
%

% % % %     % Generate skeleton and border images
[Th,B2]=skeleton_border(bw);
Th=bwmorph(Th,'clean'); % erase isolate pixels
bwTh=bwlabel(Th);  % label the "objects" (subgraph) of image

bw = bwareaopen(bw, 50); % erase small objects area <=50
B = bwmorph(bw,'remove');  % generate the vessels borders

% Generates and cleans the skeleton, making a spur using the size of the largest radio value
sk=erase_spur_avg_radius2(bw);

% Mark the skeleton, with -101 for terminals, and -3 for branches.
sk_label=mark_topo2(sk);

[x,y]=find(sk_label==-3);  % only characteristic points
pts=[x,y];

[x2,y2]=find(sk_label~=0);  % all skeleton points
pts2=[x2,y2];

end

