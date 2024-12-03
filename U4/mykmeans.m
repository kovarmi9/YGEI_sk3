function [S, L] = mykmeans(M, k, max_iter, PS)
    % M: Data points (matrix of size [num_points, n_dim])
    % k: Number of clusters
    % max_iter: Maximum number of iterations
    % PS: Convergence tolerance for centroid movement
    
    % Automatically determine the number of dimensions from M
    [~, n_dim] = size(M);  % Get number of points and dimensions

    % Range of the points
    Max = max(M);
    Min = min(M);

    % Randomly initialize centroids within the data range
    r = Min + (Max - Min) .* rand(k, n_dim);
    S = r; % Initial centroids

    % Start the k-means iteration process
    N = 0; % Iteration counter
    N_max = max_iter;

    % Loop until maximum iterations or convergence
    while N < N_max
        % Step 1: Assign points to the nearest centroid
        D = pdist2(M, S);  % Distance matrix between points and centroids
        [~, L] = min(D, [], 2);  % L contains the cluster index for each point

        % Step 2: Recompute the centroids based on the assigned points
        S_new = zeros(k, n_dim);

        for j = 1:k
            cluster_points = M(L == j, :);
            
            if isempty(cluster_points)
                % If a centroid has no points assigned, reinitialize it randomly
                S_new(j, :) = Min + (Max - Min) .* rand(1, n_dim);
            else
                S_new(j, :) = mean(cluster_points, 1);
            end
        end

        % Check for convergence by comparing the centroid movement
        diff = norm(S_new - S);
        if diff < PS
            disp('Convergence achieved.');
            break;
        end

        % Update centroids for the next iteration
        S = S_new;
        N = N + 1;
    end
end
