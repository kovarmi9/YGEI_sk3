function [component] = decompression(zigzag, Q, transType)
    % DECOMPRESSION Decompresses a zigzag vector using specified dequantization and inverse transformation
    %   zigzag - input zigzag vector
    %   Q - quantization matrix
    %   transType - type of inverse transformation ('dct', 'fft', 'dwt')
    %   component - output decompressed image component

    % Getting size of matrix
    n = sqrt(length(zigzag));
    m = n;

    % Initialize the output matrix Y with zeros
    component = zeros(m, n);

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
            Yidct = real(feval(strcat('Transformations.myi', transType), dequantized));

            % Reverse interval transformation
            component(i:i+7, j:j+7) = 0.5 * (Yidct + 255);
        end
    end
end
