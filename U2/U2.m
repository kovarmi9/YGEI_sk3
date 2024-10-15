clc; clear variables; close all; format long g

% Load the image
im=imread('MMC14_sk3.jpg');

% Getting size of rows columns and depth from 3D matricx
[row, col, dep] = size(im);

% Extract RGB components
imR=im(:,:,1);
imG=im(:,:,2);
imB=im(:,:,3);

% Rect=[6386        1891          32           80
%       1607        2033          33           76
%       3320        5462          34           80];
% 
% % Interaktivní výběr vzorku
% figure(1)
% ImR = imshow(imR);
% [J,rect] = imcrop(ImR);

% Showing original image
subplot(2,2,1)
imshow(im)
title('Original image');

% Showing template
template = imcrop(im, [2987, 3047, 40 ,80]);
subplot(2,2,3)
imshow(template)
title('Template');

% Extract of blue colour from template
template_B = template(:,:,3);

% Calculation of corelation
c = normxcorr2(template_B, imB);
subplot(2,2,2)
imshow(c)
title('Corelation');

% Find locations with correlation above 0.7
limit = 0.7;
[ypeak, xpeak] = find(c >= limit);

% Display the matching areas
subplot(2,2,4)
imshow(im)
hold on
for i = 1:length(xpeak)
    rectangle('Position', [xpeak(i) - size(template_B, 2), ypeak(i) - size(template_B, 1), size(template_B, 2), size(template_B, 1)], 'EdgeColor', 'r')
end
title('Matching areas');
hold off
