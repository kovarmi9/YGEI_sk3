clc; clear variables; close all; format long g

n_dim = 3;  % Dimension (change to 1, 2, or 3)

% Generate points in n_dim dimensions
A = randn(10, n_dim);
B = randn(15, n_dim) * 1.2 + rand(1, n_dim) * 15;
C = randn(20, n_dim) * 1.2 + rand(1, n_dim) * 20;
D = randn(25, n_dim) * 1.2 + rand(1, n_dim) * 25;

V = ["rx", "bx", "cx", "mx"];  % Cluster visualization markers

% Combine all points into one matrix
M = [A; B; C; D];

% Parameters for clustering
k = 4;  % Number of clusters for K-means and Hierarchical
epsilon = 5;  % DBSCAN: maximum distance between points
minPts = 5;   % DBSCAN: minimum points to form a cluster
max_iter = 100;  % Max iterations for K-means
PS = 0.1;   % Perturbation size for K-means

% K-means clustering
[S, L] = Clustering.kmeans(M, k, max_iter, PS);

% Hierarchical clustering
clusters_hierar = Clustering.hierar(M, k);

% DBSCAN clustering
clusters_dbscan = Clustering.dbscan(M, epsilon, minPts);

%% K-means Visualization
figure;
if n_dim == 1
    hold on;
    title('K-means Clustering');
    for i = 1:k
        cluster_points = M(L == i, :);
        scatter(cluster_points, ones(size(cluster_points)), 50, V(i));
    end
    scatter(S(:, 1), ones(size(S(:, 1))), 100, 'kx', 'LineWidth', 3);
    xlabel('Value');
    ylabel('Cluster');
    hold off;
    
elseif n_dim == 2
    hold on;
    title('K-means Clustering');
    for i = 1:k
        cluster_points = M(L == i, :);
        scatter(cluster_points(:, 1), cluster_points(:, 2), 50, V(i));
    end
    scatter(S(:, 1), S(:, 2), 100, 'kx', 'LineWidth', 3);
    axis([min(M(:,1))-5, max(M(:,1))+5, min(M(:,2))-5, max(M(:,2))+5]);
    hold off;
    
elseif n_dim == 3
    hold on;
    title('K-means Clustering');
    for i = 1:k
        cluster_points = M(L == i, :);
        scatter3(cluster_points(:, 1), cluster_points(:, 2), cluster_points(:, 3), 50, V(i));
    end
    scatter3(S(:, 1), S(:, 2), S(:, 3), 100, 'kx', 'LineWidth', 3);
    view(3);
    rotate3d on;
    hold off;
elseif n_dim == 4
    % Cut 1: e1, e2, e3 (ignoring e4)
    subplot(2, 2, 1);
    hold on;
    for i = 1:k
        cluster_points = M(L == i, :);
        scatter3(cluster_points(:,1), cluster_points(:,2), cluster_points(:,3), 50, 'Marker', 'x');
    end
    scatter3(S(:,1), S(:,2), S(:,3), 100, 'kx', 'LineWidth', 3); % Black centroids
    title('Cut e1, e2, e3');
    xlabel('e1');
    ylabel('e2');
    zlabel('e3');
    axis equal;
    view(3);
    rotate3d on;

    % Cut 2: e1, e2, e4 (ignoring e3)
    subplot(2, 2, 2);
    hold on;
    for i = 1:k
        cluster_points = M(L == i, :);
        scatter3(cluster_points(:,1), cluster_points(:,2), cluster_points(:,4), 50, 'Marker', 'x');
    end
    scatter3(S(:,1), S(:,2), S(:,4), 100, 'kx', 'LineWidth', 3); % Black centroids
    title('Cut e1, e2, e4');
    xlabel('e1');
    ylabel('e2');
    zlabel('e4');
    axis equal;
    view(3);
    rotate3d on;

    % Cut 3: e1, e3, e4 (ignoring e2)
    subplot(2, 2, 3);
    hold on;
    for i = 1:k
        cluster_points = M(L == i, :);
        scatter3(cluster_points(:,1), cluster_points(:,3), cluster_points(:,4), 50, 'Marker', 'x');
    end
    scatter3(S(:,1), S(:,3), S(:,4), 100, 'kx', 'LineWidth', 3);
    title('Cut e1, e3, e4');
    xlabel('e1');
    ylabel('e3');
    zlabel('e4');
    axis equal;
    view(3);
    rotate3d on;

    % Cut 4: e2, e3, e4 (ignoring e1)
    subplot(2, 2, 4);
    hold on;
    for i = 1:k
        cluster_points = M(L == i, :);
        scatter3(cluster_points(:,2), cluster_points(:,3), cluster_points(:,4), 50, 'Marker', 'x');
    end
    scatter3(S(:,2), S(:,3), S(:,4), 100, 'kx', 'LineWidth', 3);
    title('Cut e2, e3, e4');
    xlabel('e2');
    ylabel('e3');
    zlabel('e4');
    axis equal;
    view(3);
    rotate3d on;
end

%% Hierarchical Clustering Visualization
figure;
hold on;
title('Hierarchical Clustering');
if n_dim == 2
    for i = 1:length(clusters_hierar)
        cluster_points = M(clusters_hierar{i}, :);
        scatter(cluster_points(:, 1), cluster_points(:, 2), 50, V(i));
    end
    axis equal;
    
elseif n_dim == 3
    for i = 1:length(clusters_hierar)
        cluster_points = M(clusters_hierar{i}, :);
        scatter3(cluster_points(:, 1), cluster_points(:, 2), cluster_points(:, 3), 50, V(i));
    end
    view(3);
    rotate3d on;
end
hold off;
disp('hierar completed.');
disp('Clusters:');
disp(clusters_hierar);

%% DBSCAN Visualization
figure;
hold on;
title('DBSCAN Clustering');
if n_dim == 1
    for i = 1:length(clusters_dbscan)
        cluster_points = M(clusters_dbscan{i}, :);
        scatter(cluster_points, ones(size(cluster_points)), 50, V(i));
    end
elseif n_dim == 2
    for i = 1:length(clusters_dbscan)
        cluster_points = M(clusters_dbscan{i}, :);
        scatter(cluster_points(:, 1), cluster_points(:, 2), 50, V(i));
    end
    axis equal;
elseif n_dim == 3
    for i = 1:length(clusters_dbscan)
        cluster_points = M(clusters_dbscan{i}, :);
        scatter3(cluster_points(:, 1), cluster_points(:, 2), cluster_points(:, 3), 50, V(i));
    end
    view(3);
    rotate3d on;
end
hold off;
disp('DBSCAN completed.');
disp('Clusters:');
disp(clusters_dbscan);
