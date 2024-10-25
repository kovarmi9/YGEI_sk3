function [templates, rects] = select_samples(im, num_samples)
    % Initialize cell arrays to store the templates and their coordinates
    templates = cell(1, num_samples); % Create a cell array to store the selected templates
    rects = cell(1, num_samples); % Create a cell array to store the coordinates of the selected templates

    % Create a figure for interactive selection
    window = figure('Name', 'Selection Window'); % Open a new figure window named 'Selection Window'
    image = imshow(im); % Display the input image in the figure window
    title('Select the first sample'); % Set the title of the figure window

    % Select the first sample and get its size
    [templates{1}, rects{1}] = imcrop(image); % Allow the user to select a region of the image and store the template and its coordinates
    rect_size = rects{1}(3:4); % Store the width and height of the selected region

    % Ensure the first sample has three channels
    if size(templates{1}, 3) ~= 3
        templates{1} = repmat(templates{1}, [1, 1, 3]); % If the template does not have three channels, replicate it to create a three-channel image
    end

    % Display the first sample in a new figure
    figure('Name', 'Sample Display'); % Open a new figure window named 'Sample Display'
    imshow(templates{1}); % Display the first selected template
    title('Sample 1'); % Set the title of the figure window

    % Select more samples with the same size
    for i = 2:num_samples
        figure(window); % Bring the selection window to the front
        imshow(im); % Display the input image again
        title(['Select sample ', num2str(i)]); % Update the title to indicate the current sample number

        % Get the position of the selection
        rect = getrect(gca); % Allow the user to select a region of the image and store its coordinates

        % Set the same size as the first sample
        rect(3:4) = rect_size; % Ensure the selected region has the same width and height as the first sample
        templates{i} = imcrop(im, rect); % Crop the selected region from the image and store it as a template
        rects{i} = rect; % Store the coordinates of the selected region

        % Ensure the sample has three channels
        if size(templates{i}, 3) ~= 3
            templates{i} = repmat(templates{i}, [1, 1, 3]); % If the template does not have three channels, replicate it to create a three-channel image
        end

        % Display the selected sample in the same figure
        figure('Name', 'Sample Display'); % Bring the sample display window to the front
        imshow(templates{i}); % Display the current selected template
        title(['Sample ', num2str(i)]); % Update the title to indicate the current sample number
    end

    % Close the selection figure after selection
    close(window); % Close the selection window
end
