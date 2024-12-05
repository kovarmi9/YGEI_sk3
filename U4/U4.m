clc; clear variables; close all; format long g

% Initialize n_dim to a non-valid value
n_dim = -1;

% Ask user for the number of dimensions
while true
    % Ask the user for input
    n_dim = input('Enter dimension (positive integer): ');
    
    % Check if the input is a valid positive integer
    if isscalar(n_dim) && n_dim == fix(n_dim) && n_dim > 0
        break; % Exit loop if the input is valid
    else
        fprintf('Invalid input. Please enter a positive integer.\n');
    end
end

% 2D specific user input
if n_dim == 2
    % Ask user if points should be generated or input manually
    use_input = input('User input points? yes/no: ', 's');  % 's' means text iput

    use_input = lower(use_input);  % off key sensitivity

    if strcmp(use_input, 'yes')  % if user type 'yes'
        % Interactive input
        disp('Click on the plot to add points: Press Enter to continue.');

        % Plot for useinput
        figure(4);
        hold on;
        title('Click on the plot to add points: Press Enter to continue');
        xlabel('X');
        ylabel('Y');
        grid on;

        % Initialization for userinput points
        A = [];
        B = [];
        C = [];
        D = [];

        % NSize of graph for user input
        axis([0 25 0 25]);

        % User input interactivly
        while true
            % Function for user input
            [x, y, button] = ginput(1);

            % If enter is pressd exit loop
            if isempty(x)
                break;
            end

            % Sawe point
            A = [A; x, y]; %#ok<AGROW>

            % Disply new point on plot
            plot(x, y, 'g+', 'MarkerSize', 8, 'LineWidth', 1.5);
        end

        disp('User-added points:');
        disp(A);

    else
        % Generate random points
        A = randn(10, n_dim);
        B = randn(15, n_dim) * 1.2 + rand(1, n_dim) * 15;
        C = randn(20, n_dim) * 1.2 + rand(1, n_dim) * 20;
        D = randn(25, n_dim) * 1.2 + rand(1, n_dim) * 25;
    end
else
    % Generate points in n_dim dimensions
    A = randn(10, n_dim);
    B = randn(15, n_dim) * 1.2 + rand(1, n_dim) * 15;
    C = randn(20, n_dim) * 1.2 + rand(1, n_dim) * 20;
    D = randn(25, n_dim) * 1.2 + rand(1, n_dim) * 25;
end

V = ["rx", "bx", "cx", "mx", "gx", "yx"];  % Cluster visualization markers

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

%% Plot of clustering
if n_dim < 5
    %% K-means Visualization
    figure(1);
    hold on;
    sgtitle('K-means Clustering');
    axis equal;
    if n_dim == 1
        for i = 1:k
            cluster_points = M(L == i, :);
            scatter(cluster_points, ones(size(cluster_points)), 50, V(i));
        end
        scatter(S(:, 1), ones(size(S(:, 1))), 100, 'kx', 'LineWidth', 3);
        xlabel('Value');
        ylabel('Cluster');
        hold off;
        
    elseif n_dim == 2
        for i = 1:k
            cluster_points = M(L == i, :);
            scatter(cluster_points(:, 1), cluster_points(:, 2), 50, V(i));
        end
        scatter(S(:, 1), S(:, 2), 100, 'kx', 'LineWidth', 3);
        axis padded;
        hold off;
        
    elseif n_dim == 3
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
    figure(2);
    hold on;
    sgtitle('Hierarchical Clustering');
    axis equal;
    if n_dim == 1
        for i = 1:length(clusters_hierar)
            cluster_points = M(clusters_hierar{i}, :);
            scatter(cluster_points, ones(size(cluster_points)), 50, V(i));
        end
    elseif n_dim == 2
        for i = 1:length(clusters_hierar)
            cluster_points = M(clusters_hierar{i}, :);
            scatter(cluster_points(:, 1), cluster_points(:, 2), 50, V(i));
            axis padded;
        end
        
    elseif n_dim == 3
        for i = 1:length(clusters_hierar)
            cluster_points = M(clusters_hierar{i}, :);
            scatter3(cluster_points(:, 1), cluster_points(:, 2), cluster_points(:, 3), 50, V(i));
        end
        view(3);
        rotate3d on;
    elseif n_dim == 4
        % Cut 1: e1, e2, e3 (ignoring e4)
        subplot(2, 2, 1);
        hold on;
        for i = 1:length(clusters_hierar)
            cluster_points = M(clusters_hierar{i}, :);
            scatter3(cluster_points(:, 1), cluster_points(:, 2), cluster_points(:, 3), 50, V(i));
        end
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
        for i = 1:length(clusters_hierar)
            cluster_points = M(clusters_hierar{i}, :);
            scatter3(cluster_points(:, 1), cluster_points(:, 2), cluster_points(:, 4), 50, V(i));
        end
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
        for i = 1:length(clusters_hierar)
            cluster_points = M(clusters_hierar{i}, :);
            scatter3(cluster_points(:, 1), cluster_points(:, 3), cluster_points(:, 4), 50, V(i));
        end
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
        for i = 1:length(clusters_hierar)
            cluster_points = M(clusters_hierar{i}, :);
            scatter3(cluster_points(:, 2), cluster_points(:, 3), cluster_points(:, 4), 50, V(i));
        end
        title('Cut e2, e3, e4');
        xlabel('e2');
        ylabel('e3');
        zlabel('e4');
        axis equal;
        view(3);
        rotate3d on;
    end
    hold off;
    
    %% DBSCAN Visualization

    figure(3);
    hold on;
    sgtitle('DBSCAN Clustering');
    axis equal;
    if n_dim == 1
        for i = 1:length(clusters_dbscan)
            cluster_points = M(clusters_dbscan{i}, :);
            scatter(cluster_points, ones(size(cluster_points)), 50, V(i));
        end
    elseif n_dim == 2
        for i = 1:length(clusters_dbscan)
            cluster_points = M(clusters_dbscan{i}, :);
            scatter(cluster_points(:, 1), cluster_points(:, 2), 50, V(i));
            axis padded;
        end
        axis equal;
    elseif n_dim == 3
        for i = 1:length(clusters_dbscan)
            cluster_points = M(clusters_dbscan{i}, :);
            scatter3(cluster_points(:, 1), cluster_points(:, 2), cluster_points(:, 3), 50, V(i));
        end
        view(3);
        rotate3d on;
    elseif n_dim == 4
        % Cut 1: e1, e2, e3 (ignoring e4)
        subplot(2, 2, 1);
        hold on;
        for i = 1:length(clusters_hierar)
            cluster_points = M(clusters_hierar{i}, :);
            scatter3(cluster_points(:, 1), cluster_points(:, 2), cluster_points(:, 3), 50, V(i));
        end
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
        for i = 1:length(clusters_hierar)
            cluster_points = M(clusters_hierar{i}, :);
            scatter3(cluster_points(:, 1), cluster_points(:, 2), cluster_points(:, 4), 50, V(i));
        end
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
        for i = 1:length(clusters_hierar)
            cluster_points = M(clusters_hierar{i}, :);
            scatter3(cluster_points(:, 1), cluster_points(:, 3), cluster_points(:, 4), 50, V(i));
        end
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
        for i = 1:length(clusters_hierar)
            cluster_points = M(clusters_hierar{i}, :);
            scatter3(cluster_points(:, 2), cluster_points(:, 3), cluster_points(:, 4), 50, V(i));
        end
        title('Cut e2, e3, e4');
        xlabel('e2');
        ylabel('e3');
        zlabel('e4');
        axis equal;
        view(3);
        rotate3d on;
    end
    hold off;
end

%% Print of results

disp('K-means ');
disp('Centroids:');
disp(S);
disp('hierar ');
disp('Clusters:');
disp(clusters_hierar);
disp('DBSCAN ');
disp('Clusters:');
disp(clusters_dbscan);