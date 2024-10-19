function [Y] = decompression(Y_zigzag, YT, Q, transType)

    % Selected transformation to function transFunc
    transFunc = str2func(transType);

    % Getting size of matrix
    [m, n] = size(YT);

    % JPEG decompression
    Y = zeros(m, n);

    % Initializing counter for zigzag
    zigzag_index = 1;

    for i = 1:8:m-7
        for j = 1:8:n-7

            % Extract zigzag vectors
            Y_zigzag_block = Y_zigzag(zigzag_index, :)';

            % Increasment of zigzag index
            zigzag_index = zigzag_index + 1;

            % Convert ZigZag vectors back to 8x8 blocks
            % Not used but same as Ys Cbs and Crs... 
            Yq = ZigZag.from(Y_zigzag_block);

            % Create tiles (submatrices)
            Ys = YT(i:i+7, j:j+7);

            % Dequantization
            Ysd = Ys .* Q;

            % Apply IDCT/IFFT/IDWT
            Yidct = real(transFunc(Ysd));

            % Reverse interval transformation
            Y(i:i+7, j:j+7) = 0.5 * (Yidct + 255); 

        end
    end
end
