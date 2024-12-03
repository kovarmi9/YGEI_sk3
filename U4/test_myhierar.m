clc; clear variables; close all; format long g;

n_dim = 2;  % Dimension (change to 2 or 3)

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

% Perform agglomerative hierarchical clustering
clusters = myhierar(M, k);

% Visualize the clusters
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
