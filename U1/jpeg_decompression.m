function [Y, Cb, Cr] = jpeg_decompression(YT, CBT, CRT, Qy, Qc, m, n)
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
            Ysd = Ys .* Qc;
            CBd = CBs .* Qy;
            CRd = CRs .* Qy;

            % Apply IDCT
            Yidct = myidct(Ysd);
            CBidct = myidct(CBd);
            CRidct = myidct(CRd);

            % Overwrite tile with the decompressed one
            Y(i:i+7, j:j+7) = Yidct; 
            Cb(i:i+7, j:j+7) = CBidct;
            Cr(i:i+7, j:j+7) = CRidct;
        end
    end
end
