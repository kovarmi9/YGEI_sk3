clc; clear variables; close all; format long g

% Load the image
originalImage = imread('images/greyscale.bmp');

% Define the configurations
compression_factors = [10, 50, 70];
transformations = {'dct', 'dwt', 'fft'};
resampling_methods = {'2X2', 'NN'};

% Define the constant parts of the title and filename
title_prefix = 'Šedotonový rastr';
filename_prefix = 'sedo';

% Create a directory to save the images if it doesn't exist
output_dir = 'images/compressed_images';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

% Loop through each combination of parameters
for q = compression_factors
    for type_of_trans = transformations
        for type_of_resample = resampling_methods
            % Extract RGB components and convert from uint8 to double
            R = double(originalImage(:,:,1));
            G = double(originalImage(:,:,2));
            B = double(originalImage(:,:,3));

            % Transformation RGB to YCBCR
            Y = 0.2990 * R + 0.5870 * G + 0.1140 * B;
            CB = -0.1687 * R - 0.3313 * G + 0.5000 * B + 128;
            CR = 0.5000 * R - 0.4187 * G - 0.0813 * B + 128;

            % Downsampling chrominance components of picture
            CB_downsampled = feval(strcat('Resample.MyDResample', type_of_resample{1}), CB);
            CR_downsampled = feval(strcat('Resample.MyDResample', type_of_resample{1}), CR);

            % Quantisation matrix
            Qy = [16  11  10  16  24  40  51  61
                  12  12  14  19  26  58  60  55
                  14  13  16  24  40  87  69  56
                  14  17  22  29  51  87  80  62
                  18  22  37  26  68 109 103  77
                  24  35  55  64  81 104 113  92
                  49  64  78  87 103 121 120 101
                  72  92  95  98 112 100 103  99];

            % Chrominance matrix
            Qc = [17 18 24 47 66 99 99 99
                  18 21 26 66 99 99 99 99
                  24 26 56 99 99 99 99 99
                  47 69 99 99 99 99 99 99
                  99 99 99 99 99 99 99 99
                  99 99 99 99 99 99 99 99
                  99 99 99 99 99 99 99 99
                  99 99 99 99 99 99 99 99];

            % Update quantisation matrices according to q
            Qc = (50*Qc)/q;
            Qy = (50*Qy)/q;

            % Process input image by sub-matrices
            [m, n] = size(Y);

            % YCbCr compression using specified transformation and quantization
            [Y_zigzag] = compression(Y, Qy, type_of_trans{1});
            [CB_zigzag] = compression(CB_downsampled, Qc, type_of_trans{1});
            [CR_zigzag] = compression(CR_downsampled, Qc, type_of_trans{1});

            % Decompression using specified transformation and quantization to YCbCr
            [Y] = decompression(Y_zigzag, Qy, type_of_trans{1});
            [Cb] = decompression(CB_zigzag, Qc, type_of_trans{1});
            [Cr] = decompression(CR_zigzag, Qc, type_of_trans{1});

            % Upsampling chrominance components of picture
            Cb = feval(strcat('Resample.MyUResample', type_of_resample{1}), Cb);
            Cr = feval(strcat('Resample.MyUResample', type_of_resample{1}), Cr);

            % YCBCR to RGB
            Rd = Y + 1.4020 * (Cr - 128);
            Gd = Y - 0.3441 * (Cb - 128) - 0.7141 * (Cr - 128);
            Bd = Y + 1.7720 * (Cb - 128) - 0.0001 * (Cr - 128);

            % Convert double to uint8
            Ri = uint8(Rd);
            Gi = uint8(Gd);
            Bi = uint8(Bd);

            % Assembly raster from components
            ras2(:,:,1) = Ri;
            ras2(:,:,2) = Gi;
            ras2(:,:,3) = Bi;

            % Display the compressed image
            figure;
            imshow(ras2);
            title(sprintf('%s: %s, %s, q=%d', title_prefix, type_of_trans{1}, type_of_resample{1}, q));

            % Save the compressed image
            filename = sprintf('%s_%s_%s_q%d.bmp', filename_prefix, type_of_trans{1}, type_of_resample{1}, q);
            imwrite(ras2, fullfile(output_dir, filename));

            % Save the compressed image as EPS
            eps_filename = sprintf('%s_%s_%s_q%d.eps', filename_prefix, type_of_trans{1}, type_of_resample{1}, q);
            print(gcf, '-depsc', fullfile(output_dir, eps_filename));

            % Compute difference between original and decompressed components
            dR = R - Rd;
            dG = G - Gd;
            dB = B - Bd;

            % Compute standard deviations
            sigR = sqrt(sum(sum(dR.^2))/(m*n));
            sigG = sqrt(sum(sum(dG.^2))/(m*n));
            sigB = sqrt(sum(sum(dB.^2))/(m*n));

            % Display standard deviations
            fprintf('q = %d %s %s\n', q, type_of_trans{1}, type_of_resample{1});
            fprintf('Standard deviations:\n');
            fprintf('sigR: %.4f\n', sigR);
            fprintf('sigG: %.4f\n', sigG);
            fprintf('sigB: %.4f\n', sigB);

            % Close the figure
            close(gcf);
        end
    end
end
