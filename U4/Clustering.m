classdef Clustering
    methods (Static)
        % K-means clustering
        function [S, L] = mykmeans(M, k, max_iter, PS)
            % M: Data points (matrix of size [num_points, n_dim])
            % k: Number of clusters
            % max_iter: Maximum number of iterations
            % PS: Convergence tolerance for centroid movement
            
            % Range of the points
            Max = max(M);
            Min = min(M);

            % Randomly initialize centroids within the data range
            r = Min + (Max - Min) .* rand(k, size(M, 2));
            S = r; % Initial centroids

            % Start the k-means iteration process
            N = 0; % Iteration counter
            N_max = max_iter;

            % Loop until maximum iterations or convergence
            while N < N_max
                % Step 1: Assign points to the nearest centroid
                D = pdist2(M, S);  % Distance matrix between points and centroids
                [~, L] = min(D, [], 2); % L contains the cluster index for each point

                % Step 2: Recompute the centroids based on the assigned points
                S_new = zeros(k, size(M, 2));

                for j = 1:k
                    cluster_points = M(L == j, :);
                    
                    if isempty(cluster_points)
                        % If a centroid has no points assigned, reinitialize it randomly
                        S_new(j, :) = Min + (Max - Min) .* rand(1, size(M, 2));
                    else
                        S_new(j, :) = mean(cluster_points, 1);
                    end
                end

                % Check for convergence by comparing the centroid movement
                diff = norm(S_new - S);
                if diff < PS
                    disp('K-means convergence achieved.');
                    break;
                end

                % Update centroids for the next iteration
                S = S_new;
                N = N + 1;
            end
        end
        
        % DBSCAN clustering
        function labels = mydbscan(M, epsilon, minPts)
            % M: Data points (matrix of size [num_points, n_dim])
            % epsilon: Maximum distance between two points to be considered neighbors
            % minPts: Minimum number of points to form a dense region

            % Number of points
            n = size(M, 1);

            % Initialize cluster labels
            labels = zeros(n, 1);
            cluster_id = 0;

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
            end
        end
        
        % Hierarchical clustering
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
    end
end
