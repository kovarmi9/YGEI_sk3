function [Y] = decompression(zigzag, Q, transType)

    % Getting size of matrix
    n = sqrt(length(zigzag));
    m = n;

    % Initialize the output matrix Y with zeros
    Y = zeros(m, n);

    % Initialize the index for zigzag vector
    zigzag_index = 1;

    for i = 1:8:m-7
        for j = 1:8:n-7

            % Extract zigzag vectors
            zigzag_vector = zigzag(zigzag_index:zigzag_index+63);

            % Increment of zigzag index
            zigzag_index = zigzag_index + 64;

            % Convert ZigZag vectors back to 8x8 blocks
            block = ZigZag.from(zigzag_vector);

            % Dequantization
            dequantized = block .* Q;
            
            % Apply IDCT/IFFT/IDWT
            Yidct = real(feval(strcat('MyTransformations.i', transType), dequantized));

            % Reverse interval transformation
            Y(i:i+7, j:j+7) = 0.5 * (Yidct + 255);
        end
    end
end
