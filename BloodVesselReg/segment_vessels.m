function [bw,ImF] = segment_vessels(I,filter,binary)
%  Io, input image
%  filter: 1= vesselsness, 2 = Frangi
%  binary: 1= hysteresis, 2 = growing
%
% Function written by M. Elena Martinez-Perez, (1999)
% National Autonomous University of Mexico, UNAM
%

% Extract the green band in case it comes qwith 3 channels
[x,y,z]=size(I);
if z>1 I=I(:,:,2); end

% filter type to use to extract vessel-like property
switch filter
    case 1  % Vesselness
        ImF = vesselness2D(I,[2.5:1.0:10.5],[1;1],1.8,false);
    case 2  % Frangi
        I=double(I);
        [ImF,whatScale,Direction] = FrangiFilter2D(I);     
end

% Algorithm use to binarise the filtered image
switch binary
    case 1   % hysteresis
        bw = hysteresis3d(ImF, 0.33, 0.67, 8);
    case 2   % growing
        [Gx,Gy] = imgradientxy(ImF);
        [Gmag,Gdir] = imgradient(Gx,Gy); 
        
        % Compute class statistics and
        % Planting seeds for the region growing
        % flag value 1=Redfree, 0=Fluorescein
        flag=0;   % dark vessels
        [c,m,s,e2,G]=plant_seeds(ImF,Gmag,flag);
        seeds=c==1;
        
        % Region growing:
        c=growing_single_NOfig(e2,G,c,m,s);
        % Class vessel=1
        bw=(c==1);
end

end


