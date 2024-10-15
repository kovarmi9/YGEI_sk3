clc; clear variables; close all; format long g

% Load the image
image = imread('MMC14_sk3.jpg');

%Extract RGB components
R = image(:,:,1);
G = image(:,:,2);
B = image(:,:,3);

% Getting size of rows columns and depth from 3D matricx
[row, col, dep] = size(image);

% Showing original image
subplot(2,2,1)
imshow(image)
title('Original image');

% Showing template
template = imcrop(image, [2987, 3047, 40 ,80]);
subplot(2,2,3)
imshow(template)
title('Template');

% Extract of blue colour from template
template_B = template(:,:,3);

c = normxcorr2(template_B, B);
subplot(2,2,2)
imshow(c)
title('Corelation');

% Find locations with correlation above 50%
threshold = 0.5;
[ypeak, xpeak] = find(c >= threshold);

% Display the matching areas
subplot(2,2,4)
imshow(image)
title('Matching areas');
hold on;
for i = 1:length(ypeak)
    rectangle('Position', [xpeak(i) - size(template_B, 2), ypeak(i) - size(template_B, 1), size(template_B, 2), size(template_B, 1)], 'EdgeColor', 'r');
end
hold off;