clc; clear variables; close all; format long g

% Generate points
A = randn(10,2);
B = randn(15,2)*1.2 + [13,2];
C = randn(10,2)*1.2 + [10,15];
D = randn(10,2)*1.2 + [0,30];

V = ["rx", "bx", "cx", "mx"];

% Plot the points
figure;
plot(A(:,1), A(:,2), V(1), B(:,1), B(:,2), V(2), C(:,1), C(:,2), V(3), D(:,1), D(:,2), V(4));
hold on;

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
    
    % Expand the cluster
    k = 1;
    while k <= numel(neighbors)
        j = neighbors(k);
        
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
                neighbors = union(neighbors, new_neighbors);
            end
        end
        
        k = k + 1;
    end
end

% Plot the clusters and centroids
for i = 1:max(labels)
    cluster_points = M(labels == i, :);
    centroid = mean(cluster_points, 1);
    plot(centroid(1), centroid(2), 'gx', 'MarkerSize', 8, 'LineWidth', 2);
end
title('DBSCAN Clustering with Centroids');
hold off;

disp('Cluster labels:');
disp(labels);
