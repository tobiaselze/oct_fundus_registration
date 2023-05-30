
% Functions to generate a mosaic of OCT images using 
% the blood vessels as landmarks

% Cite: Martinez-Perez ME, Rauscher FG, Elze, T. "Development and 
% evaluation of customized software to automatically align macula and 
% optic disc centered optical coherence tomography scans based on 
% fundus projections". In Press, 2023.

% Functions written by M. Elena Martinez-Perez, (2023)
% National Autonomous University of Mexico, UNAM

These functions are compatible with Matlab Release R2019b and later.

The main function is called 'mosaic_demo.m'

To run it you should write in the command window:
> mosaic_demo(test)

 There are three posible tests to run the demo: 
% test = 1 : run for single pair with display
% test = 2 : run all pairs in the directory with display, using the 
%            "enter" key to run between each pair
% test = 3 : run all pairs in the directory with NO display

%%%%%%%%%%%%%%%%
BEFORE:
Before running mosaic_demo.m you should edit the file to 
set the paths and the input parameters:

% Set the paths
imagedir ='YOURPATH/images';      % input images
targetdir = 'YOURPATH/results';      % output results 

% Set Input parameters:
options.targetdir=targetdir;    % Directory where results will be saved
options.MaxDistance= 4.5;   % MaxDistance. Parameter ......    
                                               % Set for OCT images size (768x768). 
                                               % This parameter should be adjusted 
                                               % for the proper image size.

Input: two images which should be at 'path\images\'
            fileName_mac.tif   % image center in macula
            fileName_onh.tif    % image center in optica disc.

Output: results are save at  'path\results\'
             fileName_corresp.txt      % correspondence poinst [x1 y1 x2 y2]
             fileName_homo.txt.         % homography matix  [3 x 3]
             fileName_mosaic.png     % mosaic image
             fileName_overlap_evaluation.cvs   % parameters for the overlap evaluation






