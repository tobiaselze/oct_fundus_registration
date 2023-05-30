function [mosaic,inlierPtsOriginal,inlierPtsDistorted,matrix,r,nrmMI,percentOverlap]=generate_mosaic2(I1,I2,corresp,maxdist,display)
%
% Function written by M. Elena Martinez-Perez, (2023)
% National Autonomous University of Mexico, UNAM
%

eyeScene(:,:,1)=I1;   % im2gray solo para el caso de las fotos de Franziska porque son "color";
eyeScene(:,:,2)=I2;   % solo para el caso de las fotos de Franziska porque son "color";

% Read the first image from the image set.
I = eyeScene(:,:,1);
numImages=2;
tforms(numImages) = projective2d(eye(3));

% correspondences
% the matched points
matchedPtsOriginal=[corresp(:,2),corresp(:,1)];  % I1
matchedPtsDistorted=[corresp(:,4),corresp(:,3)]; % I2
tam=length(matchedPtsOriginal);

if display==1
    figure(2); clf; 
    f2=figure(2);
    f2.Position=[274.6   41.8  689.6  740.8];
    subplot(2,1,1);
    showMatchedFeatures(I1,I2,matchedPtsOriginal,matchedPtsDistorted,'montage');
    title('Matched points before Geometric Transformation (GT)')
end

if tam>3   % number of matched points should be larger than 3
    
    % Ask for Matlab Release version
    V1=ver;
    rel=V1(2).Release;     % (2) => Computer Vision Toolkit
    V2=str2num(rel(3:6));  % only the year
    
    if V2 <= 2013        % uses: estimateGeometricTransform
        % compute 2D transformation
        % status = 0	No error
        % status = 1	matchedPoints1 and matchedPoints2 inputs do not contain enough points
        % status = 2	Not enough inliers found
        [tformX,inlierpoints1,inlierpoints2,status] = estimateGeometricTransform(matchedPtsDistorted,matchedPtsOriginal,'similarity','MaxDistance',maxdist);
        
        matrix=tformX.T;      % homography matrix
        tforms(2).T=matrix;   % first image identity, second image transf (homog)
        
        %%%%%%%%%%%%%%%%%%%%
        inlierPtsDistorted = inlierpoints1;  % I2
        inlierPtsOriginal  = inlierpoints2;   % I1
        %%%%%%%%%%%%%%%%%%%
        
    else               % uses: estimateGeometricTransform2D
        % compute 2D transformation
        % status = 0	No error
        % status = 1	matchedPoints1 and matchedPoints2 inputs do not contain enough points
        % status = 2	Not enough inliers found
        [tformX,inlierIdx,status] = estimateGeometricTransform2D(matchedPtsDistorted,matchedPtsOriginal,'similarity','MaxDistance',maxdist);
        
        matrix=tformX.T;      % homography matrix
        tforms(2).T=matrix;   % first image identity, second image transf (homog)
        
        %%%%%%%%%%%%%%%%%%%%
        inlierPtsDistorted = matchedPtsDistorted(inlierIdx,:);  % I2
        inlierPtsOriginal  = matchedPtsOriginal(inlierIdx,:);   % I1
        %%%%%%%%%%%%%%%%%%%
    end
    
    if display==1
        figure(2);
        subplot(2,1,2);
        showMatchedFeatures(I1,I2,inlierPtsOriginal,inlierPtsDistorted,'montage');
        title('Matched Inlier Points (After GT)')
        pause(3)
    end
else
    inlierPtsDistorted=[];
    inlierPtsOriginal=[];
    matrix=[];
    disp('NO MATCHES FOUND!! \n')
end
 
%%%%%%%%%%%%%%%%%%

% Initialize variable to hold image sizes.
imageSize = zeros(numImages,2);
n=2;
I = eyeScene(:,:,n);
% Save image size.
imageSize(n,:) = size(I);

% Compute limits
for i = 1:numel(tforms)
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);
end

maxImageSize = max(imageSize);

% Find the minimum and maximum output limits.
xMin = min([1; xlim(:)]);
xMax = max([maxImageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([maxImageSize(1); ylim(:)]);

% Width and height of mosaic.
width  = round(xMax - xMin);
height = round(yMax - yMin);

% Initialize the "empty" mosaic.
mosaic = zeros([height width], 'like', I);

blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');

% Create a 2-D spatial reference object defining the size of the mosaic.
xLimits = [xMin xMax];
yLimits = [yMin yMax];
mosaicView = imref2d([height width], xLimits, yLimits);
% indices of all overlapping pixels in the mosaic:
overlap = true([height width]);

% Create the mosaic.
for i = 1:numImages
    
    I = eyeScene(:,:,i);
    warpedImage = imwarp(I, tforms(i), 'OutputView', mosaicView);
    
    if i==1
       warpedMac = warpedImage; 
    end
    if i==2
       warpedONH = warpedImage; 
    end
    
    % Generate a binary mask. 
    mask = imwarp(true(size(I,1),size(I,2)), tforms(i), 'OutputView', mosaicView);
    % iteratively calculate overlapping pixels:
    overlap = overlap & mask;
    
    % Overlay the warpedImage onto the mosaic.
    mosaic = step(blender, mosaic, warpedImage, mask);
end

% Pearson:
r = corr2(warpedMac(overlap), warpedONH(overlap));
% normalized mutual information:
nrmMI = nmi(double(warpedMac(overlap)), double(warpedONH(overlap)));
percentOverlap = 100*sum(sum(overlap)) / prod(size(I1));

end
