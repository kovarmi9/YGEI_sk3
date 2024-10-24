clc; clear variables; close all; format long g

% Load the image
im=imread('testing_image.jpg');

% Setting up crelation limit
limit = 0.5;

% Setting up radius for filtering multiple searching
radius = 10;

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
%template = imcrop(im, [2987, 3047, 40 ,80]);
template = imcrop(im, [267, 65, 40 ,80]);
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

% Find locations with correlation above limit
[rows, cols] = find(c >= limit);

% Extract correlation values at these locations
vals = c(sub2ind(size(c), rows, cols));

% Combine vals, rows, and cols and sort by vals in descending order
positions = sortrows([vals, rows, cols], -1);

% Preallocate memory for unique positions
unique_positions = zeros(size(positions));

% Setting the first unique position as the one with the highest correlation
unique_positions(1, :) = positions(1, :);

% Setting the initial number of unique values
unique_count = 1;

for i = 2:length(positions)
    
    % Calculate difference between the current position and all unique positions
    differences = unique_positions(1:unique_count, 2:3) - positions(i, 2:3);

    % Calcualte distances
    distances = sqrt(sum(differences'.^2));
    
    % Check if all distances from the current point are greater than the radius
    if all(distances > radius)
        
        % Counting of unique values
        unique_count = unique_count + 1;

        % Add the current position to the vector of unique positions
        unique_positions(unique_count, :) = positions(i, :);
    end
end

% Remove unused preallocated rows
unique_positions = unique_positions(1:unique_count, :);

% Display the matching areas
subplot(2,2,4)
imshow(im)
hold on
for i = 1:size(unique_positions, 1)
    rectangle('Position', [unique_positions(i, 3) - size(template_B, 2), unique_positions(i, 2) - size(template_B, 1), size(template_B, 2), size(template_B, 1)], 'EdgeColor', 'r')
end
title(['Matching areas: ',num2str(i)]);
hold off
