clc; clear variables; close all; format long g

% Generate points
A = randn(10,2);
B = randn(15,2)*1.2 + [13,2];
C = randn(10,2)*1.2 + [10,15];
D = randn(10,2)*1.2 + [0,30];

% Combine all points into one matrix
M = [A; B; C; D];

% Number of clusters (k)
k = 4;

% Compute the distance matrix
distance_matrix = pdist2(M, M);

% Number of all points
n = size(M, 1);

% Initialize clusters
clusters = num2cell(1:n);

for i = 1:n+1-k
    % Minimal value in matrix (excluding infinities)
    min_val = min(distance_matrix(:));
    
    % Indicies of minimal elements
    [row_indices, col_indices] = find(distance_matrix == min_val);

    % Remove pairs where row == col
    valid_pairs = row_indices ~= col_indices;
    row_indices = row_indices(valid_pairs);
    col_indices = col_indices(valid_pairs);

    % Merge clusters all valid pairs with the same minimum distance
    for j = 1:length(row_indices)
        row = row_indices(j);
        col = col_indices(j);

        % Merge the clusters
        clusters{row} = [clusters{row}, clusters{col}];
        clusters{col} = [];
    end

    % Update the distance matrix
    distance_matrix = inf(length(clusters)); % Reset matrix
    for k = 1:length(clusters)
        for l = 1:length(clusters)
            if k ~= l && ~isempty(clusters{k}) && ~isempty(clusters{l})
                % Compute the minimum distance between clusters k and l
                dist = min(pdist2(M(clusters{k}, :), M(clusters{l}, :)), [], 'all');
                distance_matrix(k, l) = dist;
                distance_matrix(l, k) = dist;
            end
        end
    end
end

non_empty_clusters = {};
for i = 1:length(clusters)
    if ~isempty(clusters{i})
        non_empty_clusters{end+1} = clusters{i};
    end
end
clusters = non_empty_clusters;  % Replace the original clusters with non-empty ones

% Plot the final clusters
V = ["rx", "bx", "cx", "mx"];
hold off;

% Loop through clusters and plot each
for i = 1:length(clusters)
    if ~isempty(clusters{i})
        cluster_points = M(clusters{i}, :);
        plot(cluster_points(:, 1), cluster_points(:, 2), V(i), 'MarkerSize', 8, 'LineWidth', 2);
        hold on;
    end
end

disp(clusters);