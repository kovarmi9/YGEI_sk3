clc; clear variables; close all; format long g

% Number of points
num_points = 200;

% Generate data
x = randn(1, num_points) * 7;
y = x * 0.1 + randn(1, num_points);
z = x * 0.05 + randn(1, num_points);

% Combining 3D data into points
points = [x; y; z];

% Computing the covariance matrix
covMatrix = cov(points');

% Computing the correlation matrix
corrMatrix = corr(points');

% Displaying covariance and correlation matrices
disp('Covariance Matrix:');
disp(covMatrix);

disp('Correlation Matrix:');
disp(corrMatrix);

% Computing eigenvalues and eigenvectors
[eigenvectors, eigenvalues] = eig(covMatrix);

% Sorting eigenvalues and eigenvectors
[eigenvalues_sorted, idx] = sort(diag(eigenvalues), 'descend');
eigenvectors_sorted = eigenvectors(:, idx);

% Displaying eigenvalues
disp('Sorted Eigenvalues:');
disp(eigenvalues_sorted);

% Visualizing the 3D data with PCA axes
figure;

% Plot the original data
scatter3(points(1, :), points(2, :), points(3, :), 'filled');
hold on;

% Plot the PCA axes
title('Generated 3D Data with PCA Axes', 'FontSize', 15);
xlabel('x', 'FontSize', 12);
ylabel('y', 'FontSize', 12);
zlabel('z', 'FontSize', 12);
grid on;
axis equal;
hold off;
