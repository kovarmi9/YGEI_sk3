clc; clear variables; close all; format long g

% Load the image
im = imread('TM25_sk3_edit.jpg');

% Getting size of rows, columns, and depth from 3D matrix
[row, col, dep] = size(im);

% Extract RGB components
imR = im(:,:,1);
imG = im(:,:,2);
imB = im(:,:,3);

% Showing original image
figure(1)
imshow(im)
title('Original image');

% Converto to CIELAB 
imLab = rgb2lab(im);

% Extraction of CIELAB components
imL = imLab(:,:,1);
imA = imLab(:,:,2);
imB = imLab(:,:,3);

% Display of CIELAB components
figure(2)
imshow(imL, [])
title('L* component');
figure(3)
imshow(imA, [])
title('a* component');
figure(4)
imshow(imB, [])
title('b* component');

figure(5)
I = rgb2hsv(im);
hsl_I = I(:,:,1);
hsl_I = hsl_I*255;
imshow(hsl_I,[])

lab_I2 = imA;
lab_I2 = uint8(lab_I2);

[L,C] = imsegkmeans(im,3);
imshow(L,[])
