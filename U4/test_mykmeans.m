clc; clear variables; close all; format long g

n_dim = 3;  % Dimension
k = 4;  % Number of clusters
max_iter = 10;  % Maximum number of iterations
PS = 0.1;  % Convergence tolerance

% Generate points in n_dim dimensions
A = randn(10, n_dim);  % Cluster A
B = randn(15, n_dim) * 1.2 + rand(1, n_dim) * 15;  % Cluster B
C = randn(10, n_dim) * 1.2 + rand(1, n_dim) * 20;  % Cluster C
D = randn(10, n_dim) * 1.2 + rand(1, n_dim) * 25;  % Cluster D

V = ["rx", "bx", "cx", "mx"];  % Color markers for each cluster

% Combine all points into one matrix
M = [A; B; C; D];

% Call the k-means function
[S, L] = mykmeans(M, k, max_iter, PS);

% Visualization code for 1D, 2D, 3D, and 4D data (as per your original code)
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
    view(3);
    rotate3d on;

elseif n_dim == 4
    figure;
    
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

hold off;
disp('Centroids after convergence:');
disp(S);
