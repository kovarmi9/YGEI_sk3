clc; clear variables; close all; format long g;

n_dim = 3;  % Dimension (change to 2 or 3)

% Generate points in n_dim dimensions
A = randn(10, n_dim);
B = randn(15, n_dim) * 1.2 + rand(1, n_dim) * 15;
C = randn(20, n_dim) * 1.2 + rand(1, n_dim) * 20;
D = randn(25, n_dim) * 1.2 + rand(1, n_dim) * 25;

V = ["rx", "bx", "cx", "mx"];  % Cluster visualization markers

% Combine all points into one matrix
M = [A; B; C; D];

% Number of clusters (k)
k = 4;

% Compute the distance matrix
distance_matrix = pdist2(M, M);

% Number of all points
n = size(M, 1);

% Initialize clusters
clusters = num2cell(1:n);

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

if n_dim == 2
    hold on;
    for i = 1:length(clusters)
        cluster_points = M(clusters{i}, :);
        scatter(cluster_points(:, 1), cluster_points(:, 2), 50, V(i));
    end
    axis equal;
elseif n_dim == 3
    hold on;
    for i = 1:length(clusters)
        cluster_points = M(clusters{i}, :);
        scatter3(cluster_points(:, 1), cluster_points(:, 2), cluster_points(:, 3), 50, V(i));
    end
    % Set the view angle
    view(3);
    rotate3d on;
end

hold off;
disp('Clusters:');
disp(clusters);