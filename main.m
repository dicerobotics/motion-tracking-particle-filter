clear; clc; close all; 
% imaqreset;
clear egoMotionComp;
clear particleFiltering;
%% Initialization
addpath('.\submodules');
addpath('.\data');

vidRdr = VideoReader('movPadCam05fps.avi');
viewer = vision.DeployableVideoPlayer;
vidRes = [vidRdr.Width, vidRdr.Height];    %[rows, col\
nPar = 500; 
XStdPos = 15;
XStdVel = 5;
deltaT = 1;
TProp = [1 0 deltaT 0; 0 1 0 deltaT; 0 0 1 0; 0 0 0 1];
Nfrm_movie = floor(vidRdr.Duration * vidRdr.FrameRate);
difThrMorph = 25; 
blkSizeMorph = 15;
winParWeight = 5;

outputVideo = VideoWriter('outPadCam05fps.avi');
outputVideo.FrameRate = vidRdr.FrameRate;
open(outputVideo)



% figure(1); hImDiff = imshow(uint8(zeros(vidRes(2), vidRes(1)))); title('imDiff')
% figure(2); hImDiffMod = imshow(uint8(zeros(vidRes(2), vidRes(1)))); title('imDiffComp')
% scaleAcm = 1; thetaAcm = 0; transXAcm = 0; transYAcm = 0;
  
%% Live Processing
% for frmId = 1:Nfrm_movie
while hasFrame(vidRdr)
	% Image Frame Acquisition
    imLive = rgb2gray(readFrame(vidRdr));   %imPrgrsBw(:, :, frmId); %imLive=snapshot(hCam);
    step(viewer, imLive);
    % Ego-Motion Compensation    
    [imDiff, T] = egoMotionComp(imLive);
% 	set(hImDiff, 'CData', imDiff); pause(0.125);
    % Morphological Analysis
    imDiffMor = morphAnalysis(imDiff, difThrMorph, blkSizeMorph);
    % Particle Filtering
    S = particleFiltering(imDiffMor, winParWeight, vidRes, nPar, TProp, XStdPos, XStdVel);
    % Particle Display
    imParticle = particleDisplay(S, imDiffMor); 
    imDual = [imLive;rgb2gray(imParticle)];
%%
%    img = imread(fullfile(workingDir,'images',imageNames{ii}));
   writeVideo(outputVideo,imDual)
% end


%%
    % figure(); imshow(imMasked);
% %% Update Values for next iteration
% 	Tinv  = inv(T);
% 	ss = Tinv(2,1); sc = Tinv(1,1);
% 	scaleRetrv = sqrt(ss*ss + sc*sc);
% 	thetaRetrv = atan2(ss,sc)*180/pi;
% 	transX = Tinv(3,1); transY = Tinv(3,2);
% 	scaleAcm = scaleAcm * scaleRetrv;
% 	thetaAcm = thetaAcm + thetaRetrv;
% 	transXAcm = transXAcm + transX;
% 	transYAcm = transYAcm + transY;
    
%     imPast = imLive;
% 	set(h2Show,'CData',imPast); drawnow;       %imshow Handle Update

%%
%     imMasked = imSegment(imLive, imRef);        %Segment Image
%     writeVideo(vidRec,imMasked);                %Write to video file
end
close(outputVideo);
disp('Program is ending')

%% Clean up
% close(vidRec);
% delete(h1Show); 
% delete(h2Show);
% delete(hCam);
% close all;

%Solve for Scale and Angle
    % Use the geometric transform, tform, to recover the scale and angle.
    % Since we computed the transformation from the distorted to the original
    % image, we need to compute its inverse to recover the distortion.
    %
    %  Let sc = s*cos(theta)
    %  Let ss = s*sin(theta)
    %
    %  Then, Tinv = [sc -ss  0;
    %                ss  sc  0;
    %                tx  ty  1]
    %
    %  where tx and ty are x and y translations, respectively.
    