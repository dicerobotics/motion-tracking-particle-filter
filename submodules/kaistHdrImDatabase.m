 %%
 function [imPrgrsBw] = kaistHdrImDatabase(scl, ang)
%  This function contain anomaly regarding scalling becuase scaling change image size which is no handled here and not required handling in real scenario
    imRepository = imread('kaistheader.jpg');
    imRepositoryBw = rgb2gray(imRepository);
%     figure(3); imshow(imRepositoryBw);
%     figure(1); h1Show = imshow(zeros(700,950,1,'uint8'));           %imshow Handle
%     title('imDisplay')
%     imPrgrsBw = uint8(zeros(700, 950, 21));

    for i=1:21
        imFramePxlIdxRows = 1:700;
        imFramePxlIdxCols = (1:950)+(50*(i-1));
        imPrgrsBwTrns = imRepositoryBw(imFramePxlIdxRows, imFramePxlIdxCols);                %smaller frames acquired from big image to immitate camera pan motion 
        imPrgrsBwScld = imresize(imPrgrsBwTrns, scl);
        imPrgrsBwRotate = imrotate(imPrgrsBwScld, ang*(i-1), 'bilinear', 'crop');        %Scaled/Rotated_Image %imLive=snapshot(hCam);
        imPrgrsBw(:,:,i) = imPrgrsBwRotate;
%         for j = 1:700
%             for k = 1:950
%                 if(imPrgrsBw(j, k, i) == 0 )
%                     imPrgrsBw(j, k, i) = 128;
%                 end
%             end
%         end
%         set(h1Show, 'CData', imPrgrsBw(:,:,i));
%     pause(0.5);
    end
    save('imPrgrsBw');
 end