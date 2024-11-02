clc; clear variables; close all; format long g

% Load the image
im = imread('MMC14_sk3.jpg');

% Setting up correlation limit
limit = 0.7;

% Select chanel
channel = 'Y';

% Select kernel
kernel = 'gaussian';

% Number of samples
num_samples = 5;

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

if strcmp(interactive_selection, 'YES')
    % Interactive selection of samples
    [templates, rects] = select_samples(im, num_samples);
else
    % Non-interactive selection of a predefined templates
    rects = [6388 1890 29 81;
             1229 1562 29 81;
             3321 5460 29 81
             1758 4828 29 81
             2990 3045 29 81];

    templates = cell(1, num_samples);
    for i = 1:num_samples
        templates{i} = imcrop(im, rects(i, :));
    end
end

% Resize all templates to the size of the first template
template_size = size(templates{1});
for i = 1:num_samples
    templates{i} = imresize(templates{i}, template_size(1:2));
end

% Calculate the average template
template = zeros(template_size, 'double'); % Initialize as double
for i = 1:num_samples
    template = template + double(templates{i});
end
template = uint8(template / num_samples); % Convert back to uint8

% Showing template
figure(1)
imshow(template)
title('Average template');

% Showing original image
figure(2)
subplot(2,2,1)
imshow(im)
title('Original image');

% Convert the image and template to selected channel and apply kernel
im_sel = process_image(im, channel, kernel);
template_sel = process_image(template, channel, kernel);

% Showing converted picture
subplot(2,2,2)
imshow(im_sel)
title('Converted picture');

% Calculation of correlation
c = normxcorr2(template_sel, im_sel);

% Showing correlation
subplot(2,2,3)
imshow(c)
title('Correlation');

% Find locations with correlation above limit
[rows, cols] = find(c >= limit);

% Check if any matching locations were found
if isempty(rows)
    error('No matching areas on the map that correspond for correlation coefficient.');
end

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
    rectangle('Position', [unique_positions(k, 3) - size(template_sel, 2), unique_positions(k, 2) - size(template_sel, 1), size(template_sel, 2), size(template_sel, 1)], 'EdgeColor', 'r')
end
title(['Matching areas: ', num2str(size(unique_positions, 1))]);
hold off

% Display the matching areas in new figure
figure(3)
imshow(im)
hold on
for k = 1:size(unique_positions, 1)
    rectangle('Position', [unique_positions(k, 3) - size(template_sel, 2), unique_positions(k, 2) - size(template_sel, 1), size(template_sel, 2), size(template_sel, 1)], 'EdgeColor', 'r')
end
title(['Matching areas: ', num2str(size(unique_positions, 1))]);
hold off

% Extract pixel coordinates of matching areas
pixel_coordinates = unique_positions(:, 2:3) - size(template_sel) / 2;

% Display pixel coordinates
disp('Center pixels of matching areas:');
disp(pixel_coordinates);