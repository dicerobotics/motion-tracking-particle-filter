clc; clear; close all;
addpath('D:\ASCL\Matlab\Target Mapping\data');
outFrameRate = 05;
% Set up the reader and writer objects.
vidRdr = VideoReader('movPadCam.mov');%vision.VideoFileReader('IMG_0564.mov');

vidRes = [vidRdr.Width, vidRdr.Height];    %[rows, col\
Nfrm_movie = floor(vidRdr.Duration * vidRdr.FrameRate);

videoFWriter = vision.VideoFileWriter('movPadCam05fps.avi','FrameRate',...
    outFrameRate);
viewer = vision.DeployableVideoPlayer;
%% 
% Write the first 50 frames from original file into a newly 
% created AVI file.
for i = 1:Nfrm_movie
    videoFrame = readFrame(vidRdr);
    if rem(i, 30/outFrameRate)==0
        viewFrame = rgb2gray(imresize(videoFrame, 0.5));
        step(videoFWriter,viewFrame);
        step(viewer, viewFrame);
    end
end
%% Close the input and output files.
% release(vidRdr);
% delete vidRdr;
release(videoFWriter);
release(viewer);
disp('vidFrmResize Ending');