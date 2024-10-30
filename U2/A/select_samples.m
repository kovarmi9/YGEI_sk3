function [templates, rects] = select_samples(im, num_samples)
    % Initialize cell arrays to store the templates and their coordinates
    templates = cell(1, num_samples); % Create a cell array to store the selected templates
    rects = cell(1, num_samples); % Create a cell array to store the coordinates of the selected templates

    % Create a figure for interactive selection
    window = figure('Name', 'Selection Window', 'WindowState', 'maximized', 'SizeChangedFcn', @(src, event) resizeUI(src)); % Open a new figure window named 'Selection Window'
    image = imshow(im, 'InitialMagnification', 'fit'); % Display the input image in the figure window
    title('Select the first sample'); % Set the title of the figure window

    % Add instructions as text in the figure
    addText(window, 'The size of this sample will be used for next samples.', 80);
    addText(window, 'Confirm the first sample with a double-click.', 60);

    % Add buttons to switch between zooming and selecting
    addButtons(window);

    % Wait for the user confirm the selection
    uiwait(window);

    % Select the first sample and get its size
    [templates{1}, rects{1}] = imcrop(image); % Allow the user to select a region of the image and store the template and its coordinates
    rect_size = rects{1}(3:4); % Store the width and height of the selected region

    % Ensure the first sample has three channels
    if size(templates{1}, 3) ~= 3
        templates{1} = repmat(templates{1}, [1, 1, 3]); % If the template does not have three channels, replicate it to create a three-channel image
    end

    % Select more samples with the same size
    for i = 2:num_samples
        figure(window); % Bring the selection window to the front
        imshow(im); % Display the input image again
        title(['Select sample ', num2str(i)]); % Update the title to indicate the current sample number

        % Add buttons to switch between zooming and selecting for next pictures
        addButtons(window);

        % Wait for the user confirm the selection
        uiwait(window);

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
    end

    % Close the selection figure after selection
    close(window); % Close the selection window
end

function addText(fig, textString, y)
    % Get the figure position
    figPos = get(fig, 'Position');
    % Calculate the center position for the text
    centerX = figPos(3) / 2;

    % Add the text
    uicontrol(fig, 'Style', 'text', 'String', textString, 'Position', [centerX - 150, y, 300, 20], 'HorizontalAlignment', 'center');
end

function addButtons(fig)
    % Get the figure position
    figPos = get(fig, 'Position');
    % Calculate the center position for the buttons
    centerX = figPos(3) / 2;

    % Buttons sizes
    buttonWidth = 120;
    buttonHeight = 40;
    spacing = 20; % Space between buttons

    % Calculate positions for the buttons
    zoomButtonX = centerX - buttonWidth - spacing / 2;
    selectButtonX = centerX + spacing / 2;

    % Add buttons to switch between zooming and selecting
    uicontrol(fig, 'Style', 'pushbutton', 'String', 'Start Zooming', 'Position', [zoomButtonX, 20, buttonWidth, buttonHeight], 'TooltipString', 'Enable zoom mode to magnify the image.', 'Callback', @(~,~) startZooming(fig));
    uicontrol(fig, 'Style', 'pushbutton', 'String', 'Start Selecting', 'Position', [selectButtonX, 20, buttonWidth, buttonHeight], 'TooltipString', 'Enable selection mode to choose a sample area.', 'Callback', @(~,~) startSelecting(fig));
end

function resizeUI(fig)
    % Get the figure position
    figPos = get(fig, 'Position');
    % Calculate the center position for the text and buttons
    centerX = figPos(3) / 2;

    % Buttons sizes
    buttonWidth = 120;
    buttonHeight = 40;
    spacing = 20; % Space between buttons

    % Calculate positions for the buttons
    zoomButtonX = centerX - buttonWidth - spacing / 2;
    selectButtonX = centerX + spacing / 2;

    % Update button positions
    zoomButton = findobj(fig, 'String', 'Start Zooming');
    selectButton = findobj(fig, 'String', 'Start Selecting');

    set(zoomButton, 'Position', [zoomButtonX, 20, buttonWidth, buttonHeight]);
    set(selectButton, 'Position', [selectButtonX, 20, buttonWidth, buttonHeight]);

    % Update text positions
    text1 = findobj(fig, 'String', 'The size of this sample will be used for next samples.');
    text2 = findobj(fig, 'String', 'Confirm the first sample with a double-click.');

    set(text1, 'Position', [centerX - 150, 80, 300, 20]);
    set(text2, 'Position', [centerX - 150, 60, 300, 20]);
end

function startZooming(fig)
    % Enable zooming
    figure(fig);
    zoom on;
    % Disable panning
    pan off;
end

function startSelecting(fig)
    % Disable zooming
    figure(fig);
    zoom off;
    % Resume the execution of the program
    uiresume;
end