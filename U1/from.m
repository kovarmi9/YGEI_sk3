function M = from(zigzag)
    %   M = INVERSEZIGZAG(zigzag) takes a vector zigzag and
    %   reconstructs a square matrix M by traversing the
    %   elements in a zigzag pattern.
    %
    %   Example:
    %       zigzag = [1, 7, 5, 9, 3, 9, 10, -5, 11, 7, 1, 8, 12, 15, 79];
    %       M = inverseZigZag(zigzag);
    %       disp(M);

    % Determine the size of the square matrix
    n = sqrt(length(zigzag));
    n = round(n);
    
    % Initialize the output matrix
    M = zeros(n, n);
    
    % Initialization matrix of sums of indices
    sumMatrix = zeros(n, n);
    
    % Filling the sum matrix with the sum of indices
    for i = 1:n
        for j = 1:n
            sumMatrix(i, j) = i + j;
        end
    end
    
    % Initialize vector for index sums
    sumVector = zeros(1, n * n);
    
    % Generate the increasing part of the vector
    index = 1;
    for k = 0:n
        sumVector(index:index+k-1) = k + 1;
        index = index + k;
    end
    
    % Generate the decreasing part of the vector
    for k = n-1:-1:1
        sumVector(index:index+k-1) = n * 2 + 1 - k;
        index = index + k;
    end
    
    % Initialize vector for positions
    positions = zeros(1, length(sumVector));
    
    % Find positions of vector values in the sum matrix
    current_row = n; % Start searching from the bottom row
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
                    positions(k) = (i-1) * n + pos; % Calculate the linear index and store it in positions
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
            for i = current_row:n
                pos = find(sumMatrix(i, :) == value, 1); % Find the position of the value in the current row
                if ~isempty(pos)
                    positions(k) = (i-1) * n + pos; % Calculate the linear index and store it in positions
                    found = true; % Set the found flag to true
                    if k < length(sumVector) && sumVector(k+1) == value
                        current_row = i + 1; % Move to the next row if the next value is the same
                    else
                        current_row = n; % Reset to the bottom row if the next value is different
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
                current_row = n; % Reset to the bottom row if the value is not found
            end
        end
    end
    
    % Fill the matrix with elements from the zigzag vector
    for k = 1:length(positions)
        row = ceil(positions(k) / n);
        col = mod(positions(k) - 1, n) + 1;
        M(row, col) = zigzag(k);
    end
end
