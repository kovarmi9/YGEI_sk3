function [YT, CBT, CRT] = jpeg_compression(Y, CB, CR, Qy, Qc, transType)

    % Selected transformation to function transFunc
    transFunc = str2func(transType);

    % Getting size of matrix
    [m, n] = size(Y);

    % JPEG compression
    YT = zeros(m, n);
    CBT = zeros(m, n);
    CRT = zeros(m, n);

    for i = 1:8:m-7
        for j = 1:8:n-7

            % Create tiles (submatrices)
            Ys = Y(i:i+7, j:j+7);
            CBs = CB(i:i+7, j:j+7);
            CRs = CR(i:i+7, j:j+7);

            % Apply DCT
            Ydct = transFunc(Ys);
            CBdct = transFunc(CBs);
            CRdct = transFunc(CRs);

            % Quantisation
            Yq = Ydct ./ Qc;% may be wrong
            CBq = CBdct ./ Qy;
            CRq = CRdct ./ Qy;

            % Round values
            Yqr = round(Yq);
            CBqr = round(CBq);
            CRqr = round(CRq);

            % Overwrite tile with the compressed one
            YT(i:i+7, j:j+7) = Yqr; 
            CBT(i:i+7, j:j+7) = CBqr;
            CRT(i:i+7, j:j+7) = CRqr;
        end
    end
end
