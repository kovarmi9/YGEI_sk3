function [YT, CBT, CRT, Y_zigzag, CB_zigzag, CR_zigzag] = jpeg_compression(Y, CB, CR, Qy, Qc, transType)

    % Selected transformation to function transFunc
    transFunc = str2func(transType);

    % Getting size of matrix
    [m, n] = size(Y);

    % JPEG compression
    YT = zeros(m, n);
    CBT = zeros(m, n);
    CRT = zeros(m, n);

    % Initialize ZigZag matrix
    Y_zigzag = [];
    CB_zigzag = [];
    CR_zigzag = [];

    for i = 1:8:m-7
        for j = 1:8:n-7

            % Create tiles (submatrices)
            Ys = Y(i:i+7, j:j+7);
            CBs = CB(i:i+7, j:j+7);
            CRs = CR(i:i+7, j:j+7);

            % Transformation of interval
            Ys_transformed = 2 * Ys - 255;
            CBs_transformed = 2 * CBs - 255;
            CRs_transformed = 2 * CRs - 255;

            % Apply DCT/FFT/DWT
            Ydct = transFunc(Ys_transformed);
            CBdct = transFunc(CBs_transformed);
            CRdct = transFunc(CRs_transformed);

            % Quantisation
            Yq = Ydct ./ Qc;% may be wrong
            CBq = CBdct ./ Qy;
            CRq = CRdct ./ Qy;

            % Round values
            Yqr = round(Yq);
            CBqr = round(CBq);
            CRqr = round(CRq);

            % ZigZag to 8x8 submatrix
            % changes size in every loop but working
            Y_zigzag = [Y_zigzag; ZigZag.to(Yqr)];
            CB_zigzag = [CB_zigzag; ZigZag.to(CBqr)];
            CR_zigzag = [CR_zigzag; ZigZag.to(CRqr)];

            % Overwrite tile with the compressed one
            YT(i:i+7, j:j+7) = Yqr;
            CBT(i:i+7, j:j+7) = CBqr;
            CRT(i:i+7, j:j+7) = CRqr;
            
        end
    end
end
