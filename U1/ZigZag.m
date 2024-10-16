% test zigzag
clc; clear variables; close all; format long g;

% Example matrix
M = [ 1,  7,  3,  1;
      5,  9,  7,  8;
      9, 10, 11, 12;
      9, -5, 15, 79];

% Get the size of the matrix
[rows, cols] = size(M);

% Initialization matrix of sums of indexs
sumMatrix = zeros(rows, cols);

% Filling the sum matrix with the sum of indexs
for i = 1:rows
    for j = 1:cols
        sumMatrix(i, j) = i + j;
    end
end