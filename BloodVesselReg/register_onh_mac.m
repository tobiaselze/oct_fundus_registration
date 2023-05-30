%
% Writen by M. Elena Martinez-Perez,  September 2021
%
% Function that generates a mosaic
%
% Papers to cite:
% 1. M. E. Martinez-Perez, A. D. Hughes, S. A. Thom, A. A. Bharath and K. H. Parker. 
% Segmentation of Blood Vessels from Red-free and Fluorescein Retinal Images. Medical 
% Image Analysis. 11 (1): 47-61, 2007.
% 2. M. E. Martinez-Perez, A. D. Hughes, A. V. Stanton, S. A. Thom, N. Chapman, 
% A. A. Bharath and K. H. Parker. Retinal Vascular Tree Morphology: A Semi-automatic 
% Quantification. IEEE Transactions on Biomedical Engineering. 49(8):912-917, 2002.
% 3. The current mosaci paper....
% 4. Hartley, Richard Zisserman, Andrew. Multiple view geometry in computer vision 
% 2nd ed. Cambridge, United Kingdom : University of Cambridge, 2003.
%
    
function register_onh_mac(onhfile,options)

targetdir = options.targetdir;

if ~exist(targetdir)
    mkdir(targetdir);
end

macfile = strrep(onhfile, '_onh.', '_mac.');

[onhfilepath,onhbasename,ext] = fileparts(onhfile);
target_fn_stub = convertStringsToChars(fullfile(targetdir, extractBefore(onhbasename, "_onh")));

I2 = imread(onhfile);
I1 = imread(macfile);

if options.display==1
    f=figure(1);clf;
    f.Position = [55.4000 41.8000 501.6000 740.8000];
    subplot(3,2,1),imshow(I1)
    title('Original images');
    subplot(3,2,2),imshow(I2)
    pause(1)
end

% Keep copy of original images for display without erasing the label
I1p=I1;
I2p=I2;

% Enhance the image in case that its mean histogram is in the dark side.
h1=imhist(I1);
[mode1,sigma1]=lmshisto2(h1',50);  % robust lms (least median of squares)
h2=imhist(I2);
[mode2,sigma2]=lmshisto2(h2',50);  % robust lms (least median of squares)

if ((mode1 < 100) || (mode2 < 120))    % half of the dinamic range
    I1=adapthisteq(I1p);  % Contrast-Limited Adaptive Histogram Equalization
    I2=adapthisteq(I2p);  % Contrast-Limited Adaptive Histogram Equalization
    % Keep copy of original for display without erasing the label
    I1p=I1;
    I2p=I2;
    disp('Contrast enhanced...')
end

% For image I1
% segment blood vessels
[vessels1,ImF1] = segment_vessels(I1,1,2); % vesselness / growing
% extract putative points
[P1,P1_2,sk1] = extract_points(vessels1);
points1=[P1_2(:,2),P1_2(:,1)];  % skeleton points

% For image I2
% segment blood vessels
[vessels2,ImF2] = segment_vessels(I2,1,2); % vesselness / growing
% extract putative points
[P2,P2_2,sk2] = extract_points(vessels2);
points2=[P2_2(:,2),P2_2(:,1)];  % skeleton points

if options.display==1
    figure(1)
    subplot(3,2,3),imshow(vessels1)
    title('Segmented blood vessels');
    subplot(3,2,4),imshow(vessels2)
    subplot(3,2,5),imshow(sk1)
    title('Feature points extraction');
    subplot(3,2,6),imshow(sk2)
    pause(3)
end

disp('Extracting points and features...')
% Extract the neighborhood features.
[features1,valid_points1] = extractFeatures(ImF1,points1,'BlockSize',23); %default 11
[features2,valid_points2] = extractFeatures(ImF2,points2,'BlockSize',23);

% Match the features.
indexPairs = matchFeatures(features1,features2,'Unique',true); % only one point match with one point

% Retrieve the locations of the corresponding points for each image.
matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

% Initial matched points
N1=fliplr(matchedPoints1);
N2=fliplr(matchedPoints2);
corres=[N1 N2];

% Generate the masaicing
disp('Generating the mosaicing...')
[mosaic,inlierPtsOriginal,inlierPtsDistorted,matrix,r,nrmMI,percentOverlap] = generate_mosaic2(I1p,I2p,corres,options.MaxDistance,options.display);
NP1=inlierPtsOriginal;
NP2=inlierPtsDistorted;

if options.display
    figure(3); clf;
    imshow(mosaic)
    title('Final Mosaicing')
    pause(5)
end

disp(['Initial matches: ' num2str(length(N1)) ' ...'])
disp(['Final matches: ' num2str(length(NP1)) ' ...'])

%%%%% WRITE RESULTS INTO DISC %%%%
new_corres=[NP1,NP2];
% save in ascii: the homography matrix v, the correspondences points in
% correspondences, the moasic image and the homography matrix
homo_name=[target_fn_stub '_homo.txt'];  % [3x3] homography
corres_name=[target_fn_stub '_corresp.txt'];   % [x1 y1 x2 y2]   (Nx4)
mosaic_name=[target_fn_stub '_mosaic.png'];    % PNG image
overlap_evaluation_name = [target_fn_stub '_overlap_evaluation.csv'];

dlmwrite(homo_name,matrix);
dlmwrite(corres_name,new_corres,'delimiter','\t','precision','%4d');
imwrite(mosaic,mosaic_name);

fid = fopen(overlap_evaluation_name,'wt');
fprintf(fid, 'pearson,normalizedMI,percentOverlap\n%f,%f,%f\n', r,nrmMI,percentOverlap);
fclose(fid);

end

