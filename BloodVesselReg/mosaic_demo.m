function mosaic_demo(test)
% Writen by M. Elena Martinez-Perez,  September 2021
%
% Function that calls register_onh_mac.m to generates a mosaic
%
% There are three posible tests to run the demo: 
% test = 1 : run for single pair with display
% test = 2 : run all pairs in the directory with display, using the 
%            "enter" key to run between each pair
% test = 3 : run all pairs in the directory with NO display
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

% Set the path of images.
% Adapted to read images: name_mac.tif and name_ohn.tif

%~ imagedir ='YOURPATH/images';      % input images
%~ targetdir = 'YOURPATH/results';   % output results 

imagedir ='D:\Proyecto-Franziska\Tobias\paper\Demo_Code\images\';
targetdir = 'D:\Proyecto-Franziska\Tobias\paper\Demo_Code\results\';

% file names
onhfiles = dir([imagedir '/*_onh.tif']); % Look for all file names 
                                         % *_onh.tif in the directory
n = length(onhfiles);                    % n = total number of image pairs

% Set Input parameters:
options.targetdir=targetdir;    % Directory where results will be saved
options.MaxDistance= 4.5;       % MaxDistance. Parameter ......    
                                % Set for OCT images size (768x768). 
                                % This parameter should be adjusted 
                                % for the proper image size.
options.display=NaN;            % 1 = diasplay; 0 = NO display


switch test
    case 1
        options.display=1;
        onhfile = onhfiles(1).name;  % use the first of the list
        fprintf('\n*****\n* ONH image %s \n*****\n', onhfile);
        register_onh_mac([imagedir onhfile], options);
    case 2
        options.display=1;
        for i=1:n
            onhfile = onhfiles(i).name;
            fprintf('\n*****\n* ONH image %s (%i/%i)\n*****\n', onhfile, i, n);
            register_onh_mac([imagedir onhfile], options);
            pause
            close all
            pause(1)
        end
    case 3
        options.display=0;
        for i=1:n
            onhfile = onhfiles(i).name;
            fprintf('\n*****\n* ONH image %s (%i/%i)\n*****\n', onhfile, i, n);
            register_onh_mac([imagedir onhfile], options);
        end
end

end
