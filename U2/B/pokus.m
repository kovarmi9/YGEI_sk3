clc; clear variables; close all; format long g

% Load the image
img = imread('TM25_sk3_edit.jpg');

% Convert the image to Lab color space
cform = makecform('srgb2lab');
lab_img = applycform(img, cform);

% Extract the 'a' and 'b' channels (color information)
ab = double(lab_img(:,:,2:3));
nrows = size(ab, 1);
ncols = size(ab, 2);
ab = reshape(ab, nrows * ncols, 2);

% Apply K-means clustering to segment colors
nColors = 6; % Number of clusters (adjust if needed)
[cluster_idx, cluster_center] = kmeans(ab, nColors, 'distance', 'sqEuclidean', 'Replicates', 6);

% Reshape cluster indices to match image dimensions
pixel_labels = reshape(cluster_idx, nrows, ncols);

% Display each cluster to identify the green cluster visually

Data={};
for i = 1:nColors
    % Create a mask for each cluster
    cluster_mask = (pixel_labels == i);
    % Apply the mask to the original image
    Data = [Data,bsxfun(@times, img, cast(cluster_mask, 'like', img))];
    figure(i)
    imshow(Data{i})
end


