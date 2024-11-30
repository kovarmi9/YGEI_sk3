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
r1 = Min(1) + (Max(1) - Min(1)) .* rand(k, 1);
r2 = Min(2) + (Max(2) - Min(2)) .* rand(k, 1);

r = [r1, r2];
S = r; % Initial centroids

% Plot initial centroids
plot(r(:,1), r(:,2), 'bx', 'MarkerSize', 8, 'LineWidth', 2);

% Start the k-means iteration process
N = 0; % Iteration counter
N_max = max_iter;

% Loop until maximum iterations or convergence
while N < N_max
    % Step 1: Assign points to the nearest centroid
    % Calculate the distance of each point to each centroid
    D = sqrt((M(:,1) - S(:,1)').^2 + (M(:,2) - S(:,2)').^2);
    
    % Find the index of the minimum distance for each point
    [~, L] = min(D, [], 2);
    
    % Step 2: Recompute the centroids based on the assigned points
    S_new = zeros(k, 2);
    
    for j = 1:k
        cluster_points = M(L == j, :);
        
        S_new(j, :) = mean(cluster_points, 1);
    end

    % Plot the previous and new centroids
    plot(S(:,1), S(:,2), 'bx', 'MarkerSize', 8, 'LineWidth', 2);
    plot(S_new(:,1), S_new(:,2), 'gx', 'MarkerSize', 8, 'LineWidth', 2);
    
    % Check for convergence by comparing the centroid movement
    diff = norm(S_new - S);
    if diff < PS
        disp('Convergence achieved.');
        break;
    end

    % Update centroids for the next iteration
    S = S_new;
    N = N + 1;

    % Pause to visualize
    pause(0.5);
end

hold off;
disp('Centroids after convergence:');
disp(S);
