%% Ego-Motion Compensation
function [imDiff, T] = egoMotionComp(imLive)
persistent imPast ptsPast featuresPast vldPtsPast
if(isempty(imPast)||isempty(ptsPast)||isempty(featuresPast)||isempty(vldPtsPast))
    imPast = imLive;
    % Find Features
    ptsPast = detectMinEigenFeatures(imPast); %detectSURFFeatures(imLive);  
    % Extract Feature Descriptors
    [featuresPast, vldPtsPast] = extractFeatures(imPast, ptsPast);
end

%% Step 1.1: Feature Selection and Tracking
% Find Features
ptsLive = detectMinEigenFeatures(imLive); %detectSURFFeatures(imLive);  
% Extract Feature Descriptors
[featuresLive, vldPtsLive] = extractFeatures(imLive, ptsLive);
% Find indices of matching features in consecutive frames
indexPairs = matchFeatures(featuresPast, featuresLive); 
% Retrieve locations of corresponding points for each image.
if size(indexPairs, 1)>10
    matchedPast = vldPtsPast(indexPairs(:,1));
    matchedLive = vldPtsLive(indexPairs(:,2));
else
    disp('One instance of Feature Mismatch');
    T = eye(3);
    imDiff = uint8(zeros(size(imLive)));
    return;
end
% Show putative point matches.
% figure(3); showMatchedFeatures(imPast,imLive,matchedPast,matchedLive);
% title('Putatively matched points (including outliers)');

%% Step 1.2: Transformation Estimation
[tform, inlierLive, inlierPast] = estimateGeometricTransform(...
    matchedLive, matchedPast, 'affine');
% Display matching point pairs used in the computation of the transformation.
% figure(4); showMatchedFeatures(imPast,imLive,inlierPast,inlierLive);
% title('Matching points (inliers only)'); legend('ptsPast','ptsLive');
% Compute the inverse transformation matrix.
T  = tform.T;

%% Step 1.3: Recover the Original Image
% Retrieve the original image by transforming the distorted image.
outputView = imref2d(size(imPast));
imRetv  = imwarp(imLive,tform,'OutputView',outputView);
% %     Compare |imPast| to |imRetv| by looking at them side-by-side in a montage.
% figure(5), imshowpair(imPast, imRetv ,'montage');

%% Find Difference Image
[imDiff] = imDiffIntersection(imPast, imRetv);

%%
imPast = imLive;
ptsPast = ptsLive;
featuresPast = featuresLive;
vldPtsPast = vldPtsLive;
end