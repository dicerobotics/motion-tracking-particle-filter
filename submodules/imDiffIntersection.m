function [imDiff]=imDiffIntersection(imPast, imRetv)
% 	Image differencing
% 	Compare both imPast and imLive to mark area of intersection
    mask = imRetv==zeros(size(imRetv));
    imPastMasked = rgb2gray(imoverlay(imPast, mask, 'black'));
    imDiff = abs(imPastMasked - imRetv);
end