function [Y, Cb, Cr] = jpeg_decompression(YT, CBT, CRT, Qy, Qc, transType)

    % Selected transformation to function transFunc
    transFunc = str2func(transType);

    % Getting size of matrix
    [m, n] = size(YT);

    % JPEG decompression
    Y = zeros(m, n);
    Cb = zeros(m, n);
    Cr = zeros(m, n);

    for i = 1:8:m-7
        for j = 1:8:n-7

            % Create tiles (submatrices)
            Ys = YT(i:i+7, j:j+7);
            CBs = CBT(i:i+7, j:j+7);
            CRs = CRT(i:i+7, j:j+7);

            % Dequantization
            Ysd = Ys .* Qc;% may be wrong
            CBd = CBs .* Qy;
            CRd = CRs .* Qy;

            % Apply IDCT
            Yidct = real(transFunc(Ysd));
            CBidct = real(transFunc(CBd));
            CRidct = real(transFunc(CRd));

            % Reverse interval transformation
            Y(i:i+7, j:j+7) = 0.5 * (Yidct + 255); 
            Cb(i:i+7, j:j+7) = 0.5 * (CBidct + 255);
            Cr(i:i+7, j:j+7) = 0.5 * (CRidct + 255);

%             % Overwrite tile with the decompressed one
%             Y(i:i+7, j:j+7) = Yidct; 
%             Cb(i:i+7, j:j+7) = CBidct;
%             Cr(i:i+7, j:j+7) = CRidct;
        end
    end
end
