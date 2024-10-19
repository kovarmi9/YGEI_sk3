function [Y] = decompression(zigzag, component, Q, transType)

    % Selected transformation to function transFunc
    transFunc = str2func(transType);

    % Getting size of matrix
    [m, n] = size(component);

    % JPEG decompression
    Y = zeros(m, n);

    % Initializing counter for zigzag
    zigzag_index = 1;

    for i = 1:8:m-7
        for j = 1:8:n-7

            % Extract zigzag vectors
            zigzag_block = zigzag(zigzag_index, :)';

            % Increasment of zigzag index
            zigzag_index = zigzag_index + 1;

            % Convert ZigZag vectors back to 8x8 blocks
            % Not used but same as s
            q = ZigZag.from(zigzag_block);

            % Create tiles (submatrices)
            s = component(i:i+7, j:j+7);

            % Dequantization
            dequantized = s .* Q;

            % Apply IDCT/IFFT/IDWT
            Yidct = real(transFunc(dequantized));

            % Reverse interval transformation
            Y(i:i+7, j:j+7) = 0.5 * (Yidct + 255); 

        end
    end
end
