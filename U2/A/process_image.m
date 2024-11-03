function output_image = process_image(im, channel, kernel)
        % PROCESS_IMAGE Convert the input RGB image to different color channels and apply optional kernels.
    %
    %   output_image = PROCESS_IMAGE(im) converts the input RGB image 'im' to grayscale.
    %
    %   output_image = PROCESS_IMAGE(im, channel) converts the input RGB image 'im' to the specified color channel.
    %   The 'channel' parameter can be one of the following:
    %       'K'           - Converts to CMYK and returns the K (black) channel.
    %       'adjustedRGB' - Reduces the yellow component in the RGB image.
    %       'Y'           - Converts to YCbCr and returns the Y (luminance) channel.
    %       'L'           - Converts to CIELAB and returns the L (lightness) channel.
    %       'grayscale'   - Converts to grayscale (default).
    %
    %   output_image = PROCESS_IMAGE(im, channel, kernel) applies the specified kernel to the converted image.
    %   The 'kernel' parameter can be one of the following:
    %       'mean'          - Applies a mean filter.
    %       'median'        - Applies a median filter.
    %       'min'           - Applies a minimum filter.
    %       'max'           - Applies a maximum filter.
    %       'morphological' - Applies a morphological opening.
    %       'std-dev'       - Applies a standard deviation filter.
    %       'gaussian'      - Applies a Gaussian filter.
    %       'none'          - No filter is applied (default).
    %
    % Example:
    %   output_image = process_image(im, 'Y', 'gaussian');
    %
    % This example reads an image, converts it to the Y channel of YCbCr
    % color space, and applies a Gaussian filter.
    
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
            output_image = rgb2gray(adjusted_rgb_image);
            
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
        case 'mean'
            h = fspecial('average', [3 3]);
            output_image = imfilter(output_image, h);
            
        case 'median'
            output_image = medfilt2(output_image, [3 3]);
            
        case 'min'
            output_image = ordfilt2(output_image, 1, ones(3, 3));
            
        case 'max'
            output_image = ordfilt2(output_image, 9, ones(3, 3));
            
        case 'morphological'
            se = strel('disk', 1);
            output_image = imopen(output_image, se);
            
        case 'std-dev'
            output_image = stdfilt(output_image, ones(3, 3));
            
        case 'gaussian'
            output_image = imgaussfilt(output_image, 2);
            
        case 'none'
            % Do nothing
            
        otherwise
            error('Invalid kernel. Choose from ''mean'', ''median'', ''min'', ''max'', ''morphological'', ''std-dev'', ''gaussian'', or ''none''.');
    end
end
