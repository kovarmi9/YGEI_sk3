function clusters = myhierar(M, k)
    % M: Data points (matrix of size [num_points, n_dim])
    % k: Number of clusters

    % Compute the distance matrix
    distance_matrix = pdist2(M, M);

    % Number of all points
    n = size(M, 1);

    % Initialize clusters
    clusters = num2cell(1:n);

    % Perform agglomerative clustering
    for i = 1:n+1-k
        % Minimal value in matrix (excluding infinities)
        min_val = min(distance_matrix(:));
        
        % Indices of minimal elements
        [row_indices, col_indices] = find(distance_matrix == min_val);

        % Remove pairs where row == col
        valid_pairs = row_indices ~= col_indices;
        row_indices = row_indices(valid_pairs);
        col_indices = col_indices(valid_pairs);

        % Merge clusters for all valid pairs with the same minimum distance
        for j = 1:length(row_indices)
            row = row_indices(j);
            col = col_indices(j);

            % Merge the clusters
            clusters{row} = [clusters{row}, clusters{col}];
            clusters{col} = [];
        end

        % Update the distance matrix
        distance_matrix = inf(length(clusters)); % Reset matrix
        for m = 1:length(clusters)
            for n = 1:length(clusters)
                if m ~= n && ~isempty(clusters{m}) && ~isempty(clusters{n})
                    % Compute the minimum distance between clusters m and n
                    dist = min(pdist2(M(clusters{m}, :), M(clusters{n}, :)), [], 'all');
                    distance_matrix(m, n) = dist;
                    distance_matrix(n, m) = dist;
                end
            end
        end
    end

    % Select non-empty clusters
    empty_indices = cellfun("isempty", clusters);
    clusters = clusters(~empty_indices);
end
