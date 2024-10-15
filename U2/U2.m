clc; clear; format long G

im=imread('MMC14_sk3.jpg');

imR=im(:,:,1);
imG=im(:,:,2);
imB=im(:,:,3);

[r,c] = size(im);

Rect=[6386        1891          32          80
      1607	      2033	        33	        76
      3320        5462          34          80];
% Interaktivní výběr vzorku
figure(1)
ImR = imshow(imR)
[J,rect] = imcrop(ImR);

