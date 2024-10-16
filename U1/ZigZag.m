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

% Initialize vector for positions
positions = zeros(1, length(sumVector));

% Find positions of vector values in the sum matrix
current_row = rows; % Start searching from the bottom row
search_direction = 'up'; % Initial search direction

% Loop for each value in sumVector
for k = 1:length(sumVector)
    value = sumVector(k); % Getting current value from sumVector
    found = false; % Initialize the found flag to false
    
    if strcmp(search_direction, 'up')
        % Search up from the bottom row
        for i = current_row:-1:1
            pos = find(sumMatrix(i, :) == value, 1); % Find the position of the value in the current row
            if ~isempty(pos)
                positions(k) = (i-1) * cols + pos; % Calculate the linear index and store it in positions
                found = true; % Set the found flag to true
                if k < length(sumVector) && sumVector(k+1) == value
                    current_row = i - 1; % Move to the previous row if the next value is the same
                else
                    current_row = 1; % Reset to the top row if the next value is different
                    search_direction = 'down'; % Change search direction
                end
                break; % Exit the inner loop if value is found
            end
        end
    else
        % Search from the top row downwards
        for i = current_row:rows
            pos = find(sumMatrix(i, :) == value, 1); % Find the position of the value in the current row
            if ~isempty(pos)
                positions(k) = (i-1) * cols + pos; % Calculate the linear index and store it in positions
                found = true; % Set the found flag to true
                if k < length(sumVector) && sumVector(k+1) == value
                    current_row = i + 1; % Move to the next row if the next value is the same
                else
                    current_row = rows; % Reset to the bottom row if the next value is different
                    search_direction = 'up'; % Change search direction
                end
                break; % Exit the inner loop once the value is found
            end
        end
    end
    
    if ~found
        if strcmp(search_direction, 'up')
            current_row = 1; % Reset to the top row if the value is not found
        else
            current_row = rows; % Reset to the bottom row if the value is not found
        end
    end
end

% Initialize zigzag vector
zigzag = zeros(1, length(positions));

% Fill zigzag vector with elements from M based on positions
for k = 1:length(positions)
    row = ceil(positions(k) / cols);
    col = mod(positions(k) - 1, cols) + 1;
    zigzag(k) = M(row, col);
end

% Display zigzag vector
disp('Zigzag vector:');
disp(zigzag);



