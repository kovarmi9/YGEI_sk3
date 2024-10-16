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

% Initialize vector for index sums
sumVector = zeros(1, rows * cols);

% Generate the increasing part of the vector
index = 1;
for n = 0:cols
    sumVector(index:index+n-1) = n + 1;
    index = index + n;
end

% Generate the decreasing part of the vector
for n = cols-1:-1:1
    sumVector(index:index+n-1) = cols * 2 + 1 - n;
    index = index + n;
end

% Display
disp(sumVector);

% Initialize vector for positions
positions = zeros(1, length(sumVector));



