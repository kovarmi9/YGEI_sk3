clc; clear variables; close all;

% Generating a set of points defining the rarea
data_points = [0, 0; 10, 0; 10, 10; 0, 10];
CN = 16;

% Generate grid points based on the boundary
T = Grid(CN, data_points);

% Plot the boundary and grid points
figure;
plot(data_points(:,1), data_points(:,2), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
hold on;
plot(T(:,1), T(:,2), 'bx', 'MarkerSize', 8, 'LineWidth', 1.5); % Grid points
title('Generated Grid with Interactive Point Input');
xlabel('X');
ylabel('Y');
grid on;

disp('Click on the plot to add points. Press Enter when done.');

% Initialize storage for user-input points
user_points = [];

% Start interactive loop for point input
while true
    % Get one point per one iteration
    [x, y, button] = ginput(1);
    
    % If Enter is pressed, exit the loop
    if isempty(x)
        break;
    end
    
    % Store the user input point
    user_points = [user_points; x, y]; %#ok<AGROW> %stopped error mesage
    
    % Plot the newly added point
    plot(x, y, 'g+', 'MarkerSize', 8, 'LineWidth', 1.5);
end

% Add the user-selected points to the plot
plot(user_points(:,1), user_points(:,2), 'g+', 'MarkerSize', 8, 'LineWidth', 1.5);
legend('Input data', 'Grid points', 'User points');

disp('User-added points:');
disp(user_points);