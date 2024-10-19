function [Y, Cb, Cr] = jpeg_decompression(Y_zigzag, CB_zigzag, CR_zigzag, YT, CBT, CRT, Qy, Qc, transType)

    % Selected transformation to function transFunc
    transFunc = str2func(transType);

    % Getting size of matrix
    [m, n] = size(YT);

    % JPEG decompression
    Y = zeros(m, n);
    Cb = zeros(m, n);
    Cr = zeros(m, n);

    % Initializing counter for zigzag
    zigzag_index = 1;

    for i = 1:8:m-7
        for j = 1:8:n-7

            % Extract zigzag vectors
            Y_zigzag_block = Y_zigzag(zigzag_index, :)';
            CB_zigzag_block = CB_zigzag(zigzag_index, :)';
            CR_zigzag_block = CR_zigzag(zigzag_index, :)';

            % Increasment of zigzag index
            zigzag_index = zigzag_index + 1;

            % Convert ZigZag vectors back to 8x8 blocks
            % Not used but same as Ys Cbs and Crs... 
            Yq = ZigZag.from(Y_zigzag_block);
            CBq = ZigZag.from(CB_zigzag_block);
            CRq = ZigZag.from(CR_zigzag_block);

            % Create tiles (submatrices)
            Ys = YT(i:i+7, j:j+7);
            CBs = CBT(i:i+7, j:j+7);
            CRs = CRT(i:i+7, j:j+7);

            % Dequantization
            Ysd = Ys .* Qc;% may be wrong
            CBd = CBs .* Qy;
            CRd = CRs .* Qy;

            % Apply IDCT/IFFT/IDWT
            Yidct = real(transFunc(Ysd));
            CBidct = real(transFunc(CBd));
            CRidct = real(transFunc(CRd));

            % Reverse interval transformation
            Y(i:i+7, j:j+7) = 0.5 * (Yidct + 255); 
            Cb(i:i+7, j:j+7) = 0.5 * (CBidct + 255);
            Cr(i:i+7, j:j+7) = 0.5 * (CRidct + 255);

        end
    end
end
