clc; clear variables; close all; format long g

% Number of points
num_points = 200;

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
covMatrix = cov(points1);

% Computing the correlation matrix
corrMatrix = corr(points2);

% Displaying covariance and correlation matrices
disp('Covariance Matrix:');
disp(covMatrix);

disp('Correlation Matrix:');
disp(corrMatrix);

% Plot the original data
figure(1)
scatter3(points1(1, :), points1(2, :), points1(3, :), 'filled');
hold on;
title('Generated 3D Data', 'FontSize', 15);
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
title('Generated 3D Data', 'FontSize', 15);
xlabel('x', 'FontSize', 12);
ylabel('y', 'FontSize', 12);
zlabel('z', 'FontSize', 12);
grid on;
axis equal;