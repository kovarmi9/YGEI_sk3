function [labels, clusters] = mydbscan(M, epsilon, minPts)
    % M: Data points (matrix of size [num_points, n_dim])
    % epsilon: Maximum distance between two points to be considered neighbors
    % minPts: Minimum number of points to form a dense region
    
    % Automatically determine the number of dimensions from M
    [n, ~] = size(M);  % Get number of points and dimensions
    
    % Initialize cluster labels
    labels = zeros(n, 1);
    cluster_id = 0;

    % Initialize clusters as a cell array
    clusters = cell(n, 1);

    % DBSCAN algorithm
    for i = 1:n
        if labels(i) ~= 0
            % Skip if the point is already visited
            continue;
        end

        % Find neighbors within epsilon distance
        neighbors = find(pdist2(M(i, :), M) <= epsilon);

        if numel(neighbors) < minPts
            % Mark as noise if not enough neighbors
            labels(i) = -1;
            continue;
        end

        % Create a new cluster
        cluster_id = cluster_id + 1;
        labels(i) = cluster_id;
        current_cluster = neighbors;

        % Expand the cluster
        k = 1;
        while k <= numel(current_cluster)
            j = current_cluster(k);

            if labels(j) == -1
                % Change noise to border point
                labels(j) = cluster_id;
            end

            if labels(j) == 0
                % Add unvisited point to the cluster
                labels(j) = cluster_id;
                new_neighbors = find(pdist2(M(j, :), M) <= epsilon);

                if numel(new_neighbors) >= minPts
                    % Add new neighbors to the list
                    current_cluster = union(current_cluster, new_neighbors);
                end
            end

            k = k + 1;
        end

        % Save cluster indices
        clusters{cluster_id} = current_cluster;
    end

    % Select non-empty clusters
    empty_indices = cellfun("isempty", clusters);
    clusters = clusters(~empty_indices);
end
