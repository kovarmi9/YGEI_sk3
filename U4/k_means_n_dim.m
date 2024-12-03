clc; clear variables; close all; format long g

n_dim = 4;  % Dimension

% Generate points in n_dim dimensions
A = randn(10, n_dim);  % Cluster A
B = randn(15, n_dim) * 1.2 + rand(1, n_dim) * 15;  % Cluster B
C = randn(10, n_dim) * 1.2 + rand(1, n_dim) * 20;  % Cluster C
D = randn(10, n_dim) * 1.2 + rand(1, n_dim) * 25;  % Cluster D

V = ["rx", "bx", "cx", "mx"];  % Color markers for each cluster

% Combine all points into one matrix
M = [A; B; C; D];

% Number of clusters (k)
k = 4;
% Maximum number of iterations for the k-means algorithm
max_iter = 10;
% Convergence tolerance for centroid movement
PS = 0.1;

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
    % Calculate the distance of each point to each centroid in n_dim dimensions
    D = pdist2(M, S);  % Distance matrix between points and centroids
    [~, L] = min(D, [], 2);  % L is now correctly calculated
    
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

% 1D clustering visualization
if n_dim == 1
    figure;
    hold on;
    for i = 1:k
        cluster_points = M(L == i, :);
        scatter(cluster_points, ones(size(cluster_points)), 50, V(i));
    end
    scatter(S(:, 1), ones(size(S(:, 1))), 100, 'kx', 'LineWidth', 3);
    
    title('1D Clustering');
    xlabel('Value');
    ylabel('Cluster');
    hold off;

elseif n_dim == 2
    figure;
    hold on;
    for i = 1:k
        cluster_points = M(L == i, :);
        scatter(cluster_points(:, 1), cluster_points(:, 2), 50, V(i));
    end
    
    scatter(S(:, 1), S(:, 2), 100, 'kx', 'LineWidth', 3);
    
    axis([min(M(:,1))-5, max(M(:,1))+5, min(M(:,2))-5, max(M(:,2))+5]);

elseif n_dim == 3
    figure;
    hold on;
    for i = 1:k
        cluster_points = M(L == i, :); 
        scatter3(cluster_points(:, 1), cluster_points(:, 2), cluster_points(:, 3), 50, V(i));
    end
    
    scatter3(S(:, 1), S(:, 2), S(:, 3), 100, 'kx', 'LineWidth', 3);
    
    % Set the view angle
    view(3);
    rotate3d on;
% Visualization for 4D data (projection of four cuts into 3D)
elseif n_dim == 4
    figure;
    
    % Cut 1: e1, e2, e3 (ignoring e4)
    subplot(2, 2, 1);
    hold on;
    % Use different colors for each cluster
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

hold off;
disp('Centroids after convergence:');
disp(S);
