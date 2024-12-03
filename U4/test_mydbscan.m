clc; clear variables; close all; format long g;

n_dim = 2;  % Dimension (change to 2 or 3)

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

% Call the DBSCAN function
[labels, clusters] = mydbscan(M, epsilon, minPts);

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
