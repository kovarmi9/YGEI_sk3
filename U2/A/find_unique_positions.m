function unique_positions = find_unique_positions(positions, radius)
    % FIND_UNIQUE_POSITIONS Find unique positions within a specified radius.
    %
    %   unique_positions = FIND_UNIQUE_POSITIONS(positions, radius) returns a matrix of unique positions
    %   from the input 'positions' matrix, where each position is considered unique if it is at least
    %   'radius' distance away from all previously found unique positions.
    %
    %   Input:
    %       positions - A matrix of positions where each row represents a position with at least two columns
    %                   for the x and y coordinates. Additional columns are allowed but not used in distance calculation.
    %       radius    - A scalar value specifying the minimum distance required between unique positions.
    %
    %   Output:
    %       unique_positions - A matrix containing the unique positions that are at least 'radius' distance
    %                          apart from each other.
    %
    % Example:
    %   unique_positions = find_unique_positions(positions, radius);
    %
    % This example finds unique positions from the 'positions' matrix where each unique position is at least
    % 2 units away from all other unique positions.

    % Preallocate memory for unique positions
    unique_positions = zeros(size(positions));

    % Setting the first unique position as the one with the highest correlation
    unique_positions(1, :) = positions(1, :);

    % Setting the initial number of unique values
    unique_count = 1;

    for i = 2:length(positions)
        % Calculate difference between the current position and all unique positions
        differences = unique_positions(1:unique_count, 2:3) - positions(i, 2:3);

        % Calculate distances
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
end
