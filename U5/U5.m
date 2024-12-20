clc; clear variables; close all; format long g

% Number of points
num_points = 200;

% Generate data
x = randn(1, num_points);
y = randn(1, num_points);

% Rotation of points1
theta = pi / 4;

% Definition of rotation matrix
rotation_matrix = [cos(theta), -sin(theta); sin(theta), cos(theta)];

% Combining data into points1
points1 = rotation_matrix * [x; y * 2];

% Create random angle for circle
circle_angle = 2 * pi * x;

% Create random radius for circle
r = y;

% Creating hole in data with radius 0.8
while any(r < 0.8)
    r(r < 0.8) = sqrt(rand(1, sum(r < 0.8)));
end

% Combining data into points2
points2 = [r .* cos(circle_angle); r .* sin(circle_angle)];

% Covariance matrix
covMatrix1 = cov(points1');
covMatrix2 = cov(points2');
disp('Covariance Matrix points1:');
disp(covMatrix1);
disp('Covariance Matrix points2:');
disp(covMatrix2);

% Correlation matrix
corrMatrix1 = corr(points1');
corrMatrix2 = corr(points2');
disp('Correlation Matrix points1:');
disp(corrMatrix1);
disp('Correlation Matrix points2:');
disp(corrMatrix2);

% Compute eigenvalues and eigenvectors for points1
[eigenvectors1, eigenvalues1] = eig(corrMatrix1);
disp('Eigenvalues points1:');
disp(diag(eigenvalues1));
disp('Eigenvectors points1:');
disp(eigenvectors1);

% Compute eigenvalues and eigenvectors for points2
[eigenvectors2, eigenvalues2] = eig(corrMatrix2);
disp('Eigenvalues points2:');
disp(diag(eigenvalues2));
disp('Eigenvectors points2:');
disp(eigenvectors2);

% Sort eigenvalues and corresponding eigenvectors for points1
[eigenvalues_sorted1, indices1] = sort(diag(eigenvalues1), 'descend');
eigvecsort1 = eigenvectors1(:, indices1);
disp('Sorted Eigenvalues points1:');
disp(eigenvalues_sorted1);
disp('Sorted Eigenvectors points1:');
disp(eigvecsort1);

% Sort eigenvalues and corresponding eigenvectors for points2
[eigenvalues_sorted2, indices2] = sort(diag(eigenvalues2), 'descend');
eigvecsort2 = eigenvectors2(:, indices2);
disp('Sorted Eigenvalues points2:');
disp(eigenvalues_sorted2);
disp('Sorted Eigenvectors points2:');
disp(eigvecsort2);

% Check if the first principal component contains at least 70% of the information for points1
info_pc1_points1 = eigenvalues_sorted1(1) / sum(eigenvalues_sorted1);
disp(['Information in the first principal component for points1: ', num2str(info_pc1_points1 * 100), '%']);

% Check if the transformation effect is minimal for points2 (difference not more than 10%)
info_pc1_points2 = eigenvalues_sorted2(1) / sum(eigenvalues_sorted2);
info_pc2_points2 = eigenvalues_sorted2(2) / sum(eigenvalues_sorted2);
diff_info_points2 = abs(info_pc1_points2 - info_pc2_points2);
disp(['Difference in information between principal components for points2: ', num2str(diff_info_points2 * 100), '%']);

% % Plot points1
figure(1)
scatter(points1(1, :), points1(2, :), 'filled');
hold on;

% Plot the principal axes for points1
for i = 1:length(eigvecsort2)
    quiver(mean(points1(1,:), 2), mean(points1(2,:), 2), eigvecsort1(1, i) * eigenvalues_sorted1(i), eigvecsort1(2, i) * eigenvalues_sorted1(i),linewidth=2);
end

sgtitle('Points1');
xlabel('x');
ylabel('y');
grid on;
axis equal;
hold off;

% Plot points2
figure(2)
scatter(points2(1, :), points2(2, :), 'filled');
hold on;

% Plot the principal axes for ponts2
for i = 1:length(eigvecsort2)
    quiver(mean(points2(1,:), 2), mean(points2(2,:), 2), eigvecsort2(1, i) * eigenvalues_sorted2(i), eigvecsort2(2, i) * eigenvalues_sorted2(i),linewidth=2);
end

sgtitle('Points2');
xlabel('x');
ylabel('y');
grid on;
axis equal;
hold off;