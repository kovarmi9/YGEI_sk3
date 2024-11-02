function output_image = process_image(im, channel, kernel)
    % Convert the input RGB image to different color channels and apply optional kernels
    
    % Set default values if arguments are not provided
    if nargin < 2 || isempty(channel)
        channel = 'grayscale';
    end
    if nargin < 3
        kernel = 'none';
    end
    
    % Convert the image to the specified color channel
    switch channel
        case 'K'
            % Convert to CMYK and return K channel
            cform = makecform('srgb2cmyk');
            cmyk_image = applycform(im, cform);
            output_image = cmyk_image(:,:,4);
            
        case 'adjustedRGB'
            % Reduce yellow component in RGB
            adjusted_rgb_image = im;
            adjusted_rgb_image(:,:,1) = im(:,:,1) - 50; % Reduce red component
            adjusted_rgb_image(:,:,2) = im(:,:,2) - 50; % Reduce green component
            output_image = adjusted_rgb_image;
            
        case 'Y'
            % Convert to YCbCr and return Y channel
            ycbcr_image = rgb2ycbcr(im);
            output_image = ycbcr_image(:,:,1);
            
        case 'L'
            % Convert to CIELAB and return L channel
            lab_image = rgb2lab(im);
            output_image = lab_image(:,:,1);
            
        case 'grayscale'
            % Convert to grayscale
            output_image = rgb2gray(im);
            
        otherwise
            error('Invalid channel. Choose from ''K'', ''adjustedRGB'', ''Y'', ''L'', or ''grayscale''.');
    end
    
    % Apply the specified kernel if any
    switch kernel
        case 'median'
            output_image = medfilt2(output_image, [3 3]);
            
        case 'gaussian'
            output_image = imgaussfilt(output_image, 2);
            
        case 'none'
            % Do nothing
            
        otherwise
            error('Invalid kernel. Choose from ''median'', ''gaussian'', or ''none''.');
    end
end
