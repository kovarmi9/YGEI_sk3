function [zigzag] = compression(component, Q, transType)
    % COMPRESSION Compresses an image component using specified transformation and quantization
    %   component - input image component (Y, CB, or CR)
    %   Q - quantization matrix
    %   transType - type of transformation ('dct', 'fft', 'dwt')
    %   zigzag - output vector

    % Transformation of interval
    componenti = 2 * component - 255;

    % Getting size of matrix
    [m, n] = size(componenti);

    % Calculate the number of 8x8 blocks
    num_blocks = (m * n) / 64;

    % Initialize ZigZag vector with zeros
    zigzag = zeros(num_blocks * 64, 1);

    % Initialize index for zigzag vector
    zigzag_index = 1;

    for i = 1:8:m-7
        for j = 1:8:n-7
            % Create tiles (submatrices)
            sub = componenti(i:i+7, j:j+7);

            % Apply DCT/FFT/DWT
            transformed = feval(strcat('Transformations.my', transType), sub);

            % Quantisation
            quantized = transformed ./ Q;

            % Round values
            quantized_rounded = round(quantized);

            % ZigZag to 8x8 submatrix and store in zigzag vector
            zigzag(zigzag_index:zigzag_index+63) = ZigZag.to(quantized_rounded);

            % Increment zigzag index
            zigzag_index = zigzag_index + 64;

        end
    end
end