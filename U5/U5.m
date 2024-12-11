clc; clear variables; close all; format long g

% Number of points
num_points = 4;

% Generate data
x = randn(1, num_points) * 7;
y = x * 0.1 + randn(1, num_points);
z = x * 0.05 + randn(1, num_points);

% Combining 3D data into points
points1 = [x; y; z];

x = randn(1, num_points);
y = randn(1, num_points);
z = randn(1, num_points);

points2 =  [x; y; z];

% Computing the covariance matrix
covMatrix1 = cov(points1);
covMatrix2 = cov(points2);

% Computing the correlation matrix
corrMatrix1 = corr(points1);
corrMatrix2 = corr(points2);

% Displaying covariance and correlation matrices
disp('Covariance Matrix (points1):');
disp(covMatrix1);
disp('Covariance Matrix (points2):');
disp(covMatrix2);

disp('Correlation Matrix (points1):');
disp(corrMatrix1);
disp('Correlation Matrix (points2):');
disp(corrMatrix2);

% Compute eigenvalues and eigenvectors for the first dataset
[eigenvectors1, eigenvalues1] = eig(covMatrix1);

% Compute eigenvalues and eigenvectors for the second dataset
[eigenvectors2, eigenvalues2] = eig(covMatrix2);

% Display eigenvalues and eigenvectors
disp('Eigenvalues (points1):');
disp(diag(eigenvalues1));
disp('Eigenvectors (points1):');
disp(eigenvectors1);

disp('Eigenvalues (points2):');
disp(diag(eigenvalues2));
disp('Eigenvectors (points2):');
disp(eigenvectors2);

% Plot the original data
figure(1)
scatter3(points1(1, :), points1(2, :), points1(3, :), 'filled');
hold on;
title('Generated 3D Data (points1)', 'FontSize', 15);
xlabel('x', 'FontSize', 12);
ylabel('y', 'FontSize', 12);
zlabel('z', 'FontSize', 12);
grid on;
axis equal;
hold off;

% Plot the original data
figure(2)
scatter3(points2(1, :), points2(2, :), points2(3, :), 'filled');
hold on;
title('Generated 3D Data (points2)', 'FontSize', 15);
xlabel('x', 'FontSize', 12);
ylabel('y', 'FontSize', 12);
zlabel('z', 'FontSize', 12);
grid on;
axis equal;