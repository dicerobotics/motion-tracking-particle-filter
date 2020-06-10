function imDiffMor = morphAnalysis(imDiff, difThr, blkSize)
% Morphological Analysis
imThresh = imDiff>difThr;
imDiffComp = bwareaopen(imThresh, blkSize, conndef(2,'maximal'));
imDiffMor = rgb2gray(imoverlay(imDiff, ~imDiffComp, 'black'));
% set(hImDiffMod, 'CData', imDiffMor); pause(0.125);
% imMasked = imoverlay(imRetv,mask,[1 0 0]);


end