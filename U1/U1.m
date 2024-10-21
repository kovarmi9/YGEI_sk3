clc; clear variables; close all; format long g

% Load the image
originalImage = imread('colour_2.bmp');

% Display the uncompressed image
figure(1)
imshow(originalImage);
title('Uncompressed Image');

% Compression factor
q = 50;

% Type of transformation (dct, fft, dwt)
type_of_trans = 'dwt';

% Do you want to use Huffman? it might take long time (YES, NO)
use_huffman = 'YES';

% Extract RGB components and convert from uint8 to double
R = double(originalImage(:,:,1));
G = double(originalImage(:,:,2));
B = double(originalImage(:,:,3));

% Transformation RGB to YCBCR
Y =   0.2990 * R + 0.5870 * G + 0.1140 * B;
CB = -0.1687 * R - 0.3313 * G + 0.5000 * B + 128;
CR =  0.5000 * R - 0.4187 * G - 0.0813 * B + 128;

% Downsampling chrominance components of picture
CB_downsampled = Resample.MyDResample2X2(CB);
CR_downsampled = Resample.MyDResample2X2(CR);

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

% JPEG compression with DCT
[Y_zigzag] = compression(Y, Qy, type_of_trans);
[CB_zigzag] = compression(CB_downsampled, Qc, type_of_trans);
[CR_zigzag] = compression(CR_downsampled, Qc, type_of_trans);

if strcmp(use_huffman, 'YES')
    % Combine all zigzag arrays into a single cell
    zigzag = {Y_zigzag, CB_zigzag, CR_zigzag};

    % Initialize cells for Huffman tables and data
    tables = cell(1, 3);
    data = cell(1, 3);

    % Loop through each zigzag array
    for i = 1:3
        if ~isreal(zigzag{i})
            % If they are complex, use Huffman for each part separately
            [table_r, data_r] = MyHuffman.CipherHuff(real(zigzag{i}));
            [table_i, data_i] = MyHuffman.CipherHuff(imag(zigzag{i}));
            tables{i} = {table_r, table_i};
            data{i} = {data_r, data_i};
        else
            % If they are not complex, use Huffman directly
            [tables{i}, data{i}] = MyHuffman.CipherHuff(zigzag{i});
        end
    end

    % Decoding using MyHuffman.DecipherHuff
    decoded_zigzag = cell(1, 3);
    for i = 1:3
        if iscell(tables{i})
            % If the numbers are complex, decode each part separately
            real_part = MyHuffman.DecipherHuff(tables{i}{1}, data{i}{1});
            imag_part = MyHuffman.DecipherHuff(tables{i}{2}, data{i}{2});
            decoded_zigzag{i} = complex(real_part, imag_part);
        else
            % If they are not complex, decode directly
            decoded_zigzag{i} = MyHuffman.DecipherHuff(tables{i}, data{i});
        end
    end

    % Assign decoded zigzag arrays back to original variables
    Y_zigzag = decoded_zigzag{1};
    CB_zigzag = decoded_zigzag{2};
    CR_zigzag = decoded_zigzag{3};
end

% JPEG decompression with DCT
[Y] = decompression(Y_zigzag, Qy, type_of_trans);
[Cb] = decompression(CB_zigzag, Qc, type_of_trans);
[Cr] = decompression(CR_zigzag, Qc, type_of_trans);

% Upsampling chrominance components of picture
Cb = Resample.MyUResample2X2(Cb);
Cr = Resample.MyUResample2X2(Cr);

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
