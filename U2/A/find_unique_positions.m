function unique_positions = find_unique_positions(positions, radius)
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
