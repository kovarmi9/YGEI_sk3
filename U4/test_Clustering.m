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

% Number of clusters (k), epsilon for DBSCAN, minPts for DBSCAN
k = 3;
epsilon = 5;
minPts = 5;
max_iter = 100;
PS = 0.1;

% K-means clustering
[S, L] = Clustering.mykmeans(M, k, max_iter, PS);

% Hierarchical clustering
clusters_hierarchical = Clustering.myhierar(M, k);

% DBSCAN clustering
labels_dbscan = Clustering.mydbscan(M, epsilon, minPts);

%% K-means Visualization
figure;
hold on;
title('K-means Clustering');
for i = 1:k
    cluster_points = M(L == i, :);
    scatter(cluster_points(:, 1), cluster_points(:, 2), 50, V(i));
end
scatter(S(:, 1), S(:, 2), 100, 'kx', 'LineWidth', 3);
axis([min(M(:,1))-5, max(M(:,1))+5, min(M(:,2))-5, max(M(:,2))+5]);
hold off;
disp('Centroids after K-means convergence:');
disp(S);

%% Hierarchical Clustering Visualization
figure;
hold on;
title('Hierarchical Clustering');
for i = 1:length(clusters_hierarchical)
    cluster_points = M(clusters_hierarchical{i}, :);
    scatter(cluster_points(:, 1), cluster_points(:, 2), 50, V(i));
end
axis equal;
hold off;
disp('Clusters from Hierarchical clustering:');
disp(clusters_hierarchical);

%% DBSCAN Visualization
figure;
hold on;
title('DBSCAN Clustering');
% Create dynamic colors for DBSCAN visualization
colors = lines(max(labels_dbscan));  % Unique colors for clusters
for i = 1:max(labels_dbscan)
    cluster_points = M(labels_dbscan == i, :);
    if ~isempty(cluster_points)
        scatter(cluster_points(:, 1), cluster_points(:, 2), 50, 'Marker', 'x', 'MarkerFaceColor', colors(i, :));
    end
end
hold off;
disp('Clusters from DBSCAN:');
disp(labels_dbscan);
