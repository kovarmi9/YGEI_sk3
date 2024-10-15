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
