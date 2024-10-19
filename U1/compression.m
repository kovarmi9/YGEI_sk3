function [T, zigzag] = compression(component, Q, transType)

    % Selected transformation to function transFunc
    transFunc = str2func(transType);

    % Getting size of matrix
    [m, n] = size(component);

    % JPEG compression
    T = zeros(m, n);

    % Initialize ZigZag matrix
    zigzag = [];

    for i = 1:8:m-7
        for j = 1:8:n-7

            % Create tiles (submatrices)
            sub = component(i:i+7, j:j+7);

            % Transformation of interval
            subi = 2 * sub - 255;

            % Apply DCT/FFT/DWT
            transformed = transFunc(subi);

            % Quantisation
            quantized = transformed ./ Q;

            % Round values
            qr = round(quantized);

            % ZigZag to 8x8 submatrix
            % changes size in every loop but working
            zigzag = [zigzag; ZigZag.to(qr)];

            % Overwrite tile with the compressed one
            T(i:i+7, j:j+7) = qr;
            
        end
    end
end
