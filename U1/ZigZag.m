% test zigzag
clc; clear variables; close all; format long g;

% Example matrix
M = [ 1,  7,  3,  1;
      5,  9,  7,  8;
      9, 10, 11, 12;
      9, -5, 15, 79];

% Get the size of the matrix
[rows, cols] = size(M);