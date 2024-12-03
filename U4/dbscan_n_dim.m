clc; clear variables; close all; format long g;

n_dim = 3;  % Dimension (change to 2 or 3)

% Generate points in n_dim dimensions
A = randn(10, n_dim);
B = randn(15, n_dim) * 1.2 + rand(1, n_dim) * 15;
C = randn(20, n_dim) * 1.2 + rand(1, n_dim) * 20;
D = randn(25, n_dim) * 1.2 + rand(1, n_dim) * 25;

% Combine all points into one matrix
M = [A; B; C; D];

% Parameters for DBSCAN
epsilon = 5; % Maximum distance between two points to be considered neighbors
minPts = 5; % Minimum number of points to form a dense region

% Number of points
n = size(M, 1);

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

% Create dynamic colors
colors = lines(length(clusters));

% Visualize the clusters
hold on;
for i = 1:length(clusters)
    cluster_points = M(clusters{i}, :);
    % Use dynamic colors
    if n_dim == 2
        scatter(cluster_points(:, 1), cluster_points(:, 2), 50, 'Marker', 'x', 'MarkerFaceColor', colors(i, :));
    elseif n_dim == 3
        scatter3(cluster_points(:, 1), cluster_points(:, 2), cluster_points(:, 3), 50, 'Marker', 'x', 'MarkerFaceColor', colors(i, :));
    end
end
if n_dim == 3
    view(3);
    rotate3d on;
end

hold off;

disp('Clusters:');
disp(clusters);
