function output_image = convert_colour(im, component)
    % Convert the input RGB image to different color spaces and return the specified variant
    
    switch component
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

        case 'median'
            % Apply median kernel
            gray_image = rgb2gray(im);
            output_image = medfilt2(gray_image, [3 3]);
            
        case 'gaussian'
            % Apply gaussian kernel
            gray_image = rgb2gray(im);
            output_image = imgaussfilt(gray_image, 2);
            
        otherwise
            error('Invalid method. Choose from ''K'', ''adjustedRGB'', ''Y'', or ''L''.');
    end
end
