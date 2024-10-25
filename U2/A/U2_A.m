clc; clear variables; close all; format long g

% Load the image
im = imread('testing_image.jpg');

% Setting up correlation limit
limit = 0.5;

% Number of samples
num_samples = 3;

% Setting up radius for filtering multiple searching
radius = 10;

% Turn on/off interactive selection
interactive_selection = 'YES';

% Getting size of rows columns and depth from 3D matrix
[row, col, dep] = size(im);

% Extract RGB components
imR = im(:,:,1);
imG = im(:,:,2);
imB = im(:,:,3);

% Rect for non-interactive selection
% Rect = [6386 1891 32 80;
%         1607 2033 33 76;
%         3320 5462 34 80];

if strcmp(interactive_selection, 'YES')
    % Interactive selection of samples
    [templates, rects] = select_samples(im, num_samples);

    % Display all selected samples in one figure
    figure(1);
    for j = 1:num_samples
        subplot(1, num_samples, j);
        imshow(templates{j});
        title(['Sample ', num2str(j)]);
    end
else
    % Non-interactive selection of a predefined template
    template = imcrop(im, [267, 65, 40, 80]);
end

% Showing original image
subplot(2,2,1)
imshow(im)
title('Original image');

% Showing template
if strcmp(interactive_selection, 'YES')
    template = templates{1}; % Use the first template for demonstration
end
subplot(2,2,3)
imshow(template)
title('Template');

% Extract of blue colour from template
template_B = template(:,:,3);

% Calculation of correlation
c = normxcorr2(template_B, imB);

% Showing correlation
subplot(2,2,2)
imshow(c)
title('Correlation');

% Find locations with correlation above limit
[rows, cols] = find(c >= limit);

% Extract correlation values at these locations
vals = c(sub2ind(size(c), rows, cols));

% Combine vals, rows, and cols and sort by vals in descending order
positions = sortrows([vals, rows, cols], -1);

% Find unique positions (you need to define this function)
unique_positions = find_unique_positions(positions, radius);

% Display the matching areas
subplot(2,2,4)
imshow(im)
hold on
for k = 1:size(unique_positions, 1)
    rectangle('Position', [unique_positions(k, 3) - size(template_B, 2), unique_positions(k, 2) - size(template_B, 1), size(template_B, 2), size(template_B, 1)], 'EdgeColor', 'r')
end
title(['Matching areas: ', num2str(size(unique_positions, 1))]);
hold off
