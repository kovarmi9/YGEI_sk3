clc; clear variables; close all; format long g

% Load the image
originalImage = imread('colour_2.tiff');

% Display the uncompressed image
figure(1)
imshow(originalImage);
title('Uncompressed Image');

% Compression factor
q = 50;

% Extract RGB components and convert from uint8 to double
R = double(originalImage(:,:,1));
G = double(originalImage(:,:,2));
B = double(originalImage(:,:,3));

% Transformation RGB to YCBCR
Y =   0.2990 * R + 0.5870 * G + 0.1140 * B;
CB = -0.1687 * R - 0.3313 * G + 0.5000 * B + 128;
CR =  0.5    * R - 0.4187 * G - 0.0813 * B + 128;

% Quantisation matrix
Qy = [16  11  10  16  24  40  51  61
      12  12  14  19  26  58  60  55
      14  13  16  24  40  87  69  56
      14  17  22  29  51  87  80  62
      18  22  37  26  68 109 103  77
      24  35  55  64  81 104 113  92
      49  64  78  87 103 121 120 101
      72  92  95  98 112 100 103  99];

% Chrominance matrix
Qc = [17 18 24 47 66 99 99 99
      18 21 26 66 99 99 99 99
      24 26 56 99 99 99 99 99
      47 69 99 99 99 99 99 99
      99 99 99 99 99 99 99 99
      99 99 99 99 99 99 99 99
      99 99 99 99 99 99 99 99
      99 99 99 99 99 99 99 99];

% Update quantisation matrices according to q
Qc = (50*Qc)/q;
Qy = (50*Qy)/q;

% Process input easter by sub-matrices
[m, n] = size(Y);

% JPEG compression
for i = 1:8:m-7
    for j=1:8:n-7

        % Create tiles (submatrices)
        Ys = Y(i:i+7,j:j+7);
        CBs = CB(i:i+7,j:j+7);
        CRs = CR(i:i+7,j:j+7);

        % Apply DCT
        Ydct = mydct(Ys);
        CBdct = mydct(CBs);
        CRdct = mydct(CRs);

        % Quantisation
        Yq = Ydct./Qc;
        CBq = CBdct./Qy;
        CRq = CRdct./Qy;
        
        % Round values
        Yqr = round(Yq);
        CBqr = round(CBq);
        CRqr = round(CRq);

        % Overwrite tile with the compressed one
        YT(i:i+7,j:j+7) = Yqr; 
        CBT(i:i+7,j:j+7) = CBqr;
        CRT(i:i+7,j:j+7) = CRqr;
    end
end

% JPEG decompression
for i = 1:8:m-7
    for j=1:8:n-7

        % Create tiles (submatrices)
        Ys = YT(i:i+7,j:j+7);
        CBs = CBT(i:i+7,j:j+7);
        CRs = CRT(i:i+7,j:j+7);

        % Dequantization
        Ysd = Ys.*Qc;
        CBd = CBs.*Qy;
        CRd = CRs.*Qy;

        % Apply IDCT
        Yidct = myidct(Ysd);
        CBidct = myidct(CBd);
        CRidct = myidct(CRd);

        % Overwrite tile with the compressed one
        Y(i:i+7,j:j+7) = Yidct; 
        Cb(i:i+7,j:j+7) = CBidct;
        Cr(i:i+7,j:j+7) = CRidct;
    end
end

% YCBCR to RGB
Rd = Y+ 1.4020*(Cr-128);
Gd = Y-0.3441*(Cb-128) - 0.7141*(Cr-128);
Bd = Y + 1.7720 * (Cb-128) - 0.0001*(Cr-128);

% Convert double to uint8
Ri=uint8(Rd);
Gi=uint8(Gd);
Bi=uint8(Bd);

% Assembly raster from components
ras2(:,:,1) = Ri;
ras2(:,:,2) = Gi;
ras2(:,:,3) = Bi;

figure(2)
imshow(ras2);
title('Compressed Image');

% Compute standard deviations
dR = R - Rd;
dG = G - Gd;
dB = B - Bd;

dR2 = dR.^2;
dG2 = dG.^2;
dB2 = dB.^2;

sigR = sqrt(sum(sum(dR2))/(m*n));
sigG = sqrt(sum(sum(dG2))/(m*n));
sigB = sqrt(sum(sum(dB2))/(m*n));


function Rt=mydct(R)
% Function for directe cosine transformation on 8x8 block

    % Initialization of output matrix
    Rt = R;
    % Output raster: rows
    for u = 0:7
        % Cu
        if u == 0
            Cu = sqrt(2)/2;
        else
            Cu = 1;
        end
        % Output raster: columns
        for v = 0:7
            if v == 0
                Cv = sqrt(2)/2;
            else
                Cv = 1;
            end
            % Input raster: rows
            F = 0;
            for x = 0:7
                % Input raster: columns
                for y = 0:7
                    F=F+1/4*Cu*Cv*(R(x+1, y+1)*cos((2*x+1)*u*pi/16)*cos((2*y+1)*v*pi/16));
                end
            end
            % Output raster
            Rt(u+1,v+1) = F;
        end
    end
end

function Rt=myidct(R)
% Function for inverse directe cosine transformation on 8x8 block

    % Initialization of output matrix
    Rt = R; 
    % Output raster: rows
    for x = 0:7    
        % Output raster: columns
        for y = 0:7
            % Input raster: rows
            F = 0;
            for u = 0:7
                % Cu
                if u == 0
                    Cu = sqrt(2)/2;
                else
                     Cu = 1;
                end
                % Input raster: columns
                for v = 0:7
                    % Cv
                    if v == 0
                        Cv = sqrt(2)/2;
                    else
                        Cv = 1;
                    end
                    F=F+1/4*Cu*Cv*(R(u+1, v+1)*cos((2*x+1)*u*pi/16)*cos((2*y+1)*v*pi/16));
                end
            end
            % Output raster
            Rt(x+1,y+1) = F;
        end
    end
end

