classdef Transformations
    % Transformations Class for various transformations of image.
    %
    % This class provides static methods for performing Discrete Cosine Transform (DCT),
    % Inverse Discrete Cosine Transform (IDCT), Discrete Wavelet Transform (DWT),
    % Inverse Discrete Wavelet Transform (IDWT), Fast Fourier Transform (FFT),
    % and Inverse Fast Fourier Transform (IFFT).
    %
    % Methods:
    %   mydct  - Discrete Cosine Transform on an 8x8 block.
    %   myidct - Inverse Discrete Cosine Transform on an 8x8 block.
    %   mydwt  - Discrete Wavelet Transform on an 8x8 block.
    %   myidwt - Inverse Discrete Wavelet Transform on an 8x8 block.
    %   myfft  - Fast Fourier Transform on a 2D matrix.
    %   myifft - Inverse Fast Fourier Transform on a 2D matrix.
    methods (Static)
        function Rt = mydct(R)
        %   Rt = Transformations.dct(R) performs the DCT on the input
        %   8x8 block R and returns the transformed block Rt.
        %
        %   Example:
        %       R = rand(8, 8) * 255;
        %       Rt = Transformations.dct(R);
            Rt = Transformations.my_dct(R);
        end
        
        function R = myidct(Rt)
        %   R = Transformations.idct(Rt) performs the IDCT on the input
        %   8x8 block Rt and returns the transformed block R.
        %
        %   Example:
        %       R = Transformations.idct(Rt);
            R = Transformations.my_idct(Rt);
        end
        
        function Rt = mydwt(R)
        %   Rt = Transformations.dwt(R) performs the DWT on the
        %   input 8x8 block and returns the transformed block.
        %
        %   Example:
        %       Rt = Transformations.dwt(R);
            Rt = Transformations.my_dwt2(R);
        end
        
        function R = myidwt(Rt)
        %   R = Transformations.idwt(Rt) performs the IDWT on the
        %   input 8x8 block Rt and returns the transformed block R.
        %
        %   Example:
        %       R = Transformations.idwt(Rt);
            R = Transformations.my_idwt2(Rt);
        end
        
        function Rt = myfft(R)
        %   Rt = Transformations.fft(R) performs the FFT on the input
        %   2D matrix R and returns the transformed matrix Rt.
        %
        %   Example:
        %       Rt = Transformations.dft(R);
            Rt = Transformations.my_fft2(R);
        end
        
        function R = myifft(Rt)
        %   R = Transformations.ifft(Rt) performs the IFFT on the input
        %   2D matrix Rt and returns the transformed matrix R.
        %
        %   Example:
        %       R = Transformations.idft(Rt);
            R = Transformations.my_ifft2(Rt);
        end
    end
    
    methods (Static, Access = private)
        function Rt=my_dct(R)
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
        
        function Rt=my_idct(R)
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
        
        function output = my_dwt2(block)
        % Function for dwt

            % Getting size
            [rows, cols] = size(block);
        
            % Horizontal transformation
            L = zeros(rows, cols/2);
            H = zeros(rows, cols/2);
            
            for i = 1:rows
                even_cols = block(i, 1:2:end);
                odd_cols = block(i, 2:2:end);
                L(i, :) = (even_cols + odd_cols) / 2;
                H(i, :) = (even_cols - odd_cols) / 2;
            end
            
            % Vertical transformation
            LL = zeros(rows/2, cols/2);
            LH = zeros(rows/2, cols/2);
            HL = zeros(rows/2, cols/2);
            HH = zeros(rows/2, cols/2);
            
            for j = 1:cols/2
                even_rows_L = L(1:2:end, j);
                odd_rows_L = L(2:2:end, j);
                even_rows_H = H(1:2:end, j);
                odd_rows_H = H(2:2:end, j);
                
                LL(:, j) = (even_rows_L + odd_rows_L) / 2;
                LH(:, j) = (even_rows_L - odd_rows_L) / 2;
                HL(:, j) = (even_rows_H + odd_rows_H) / 2;
                HH(:, j) = (even_rows_H - odd_rows_H) / 2;
            end
            
            % Assemble the output 8x8 block
            output = [LL, LH; HL, HH];
        end
        
        function block = my_idwt2(LL)
        % Function for inverse DWT

            % Getting size
            [rows, cols] = size(LL);
            
            % Split into sub-blocks
            LL_sub = LL(1:4, 1:4);
            LH_sub = LL(1:4, 5:8);
            HL_sub = LL(5:8, 1:4);
            HH_sub = LL(5:8, 5:8);
            
            % Reconstruct even and odd rows
            L = zeros(rows, cols/2);
            H = zeros(rows, cols/2);
            
            for j = 1:cols/2
                even_rows_L = LL_sub(:, j) + LH_sub(:, j);
                odd_rows_L = LL_sub(:, j) - LH_sub(:, j);
                even_rows_H = HL_sub(:, j) + HH_sub(:, j);
                odd_rows_H = HL_sub(:, j) - HH_sub(:, j);
                
                L(1:2:end, j) = even_rows_L;
                L(2:2:end, j) = odd_rows_L;
                H(1:2:end, j) = even_rows_H;
                H(2:2:end, j) = odd_rows_H;
            end
            
            % Reconstruct even and odd columns
            block = zeros(rows, cols);
            
            for i = 1:rows
                even_cols = L(i, :) + H(i, :);
                odd_cols = L(i, :) - H(i, :);
                
                block(i, 1:2:end) = even_cols;
                block(i, 2:2:end) = odd_cols;
            end
        end
        
        function F = my_fft(x)
        % Calculate FFT with recursion
            
            % Length of the input vector
            n = length(x);
        
            % If n <= 1, the function returns the input vector x as output F
            if  n <= 1
                F = x;
            else
                % Spliting input into even and odd and another calling of function
                even = Transformations.my_fft(x(1:2:end));
                odd = Transformations.my_fft(x(2:2:end));
        
                % Inicialization of F
                F = zeros(1, n);
        
                % Combination of results
                for k = 1:n/2
                    t = exp(-2i * pi * (k-1) / n) * odd(k); % https://en.wikipedia.org/wiki/Fast_Fourier_transform
                    F(k) = even(k) + t; % Combines the corresponding elements from the even and odd vectors and stores the result in the first half of the vector F
                    F(k + n/2) = even(k) - t; % Difference of the corresponding elements from the even and odd vectors into the second half of the vector F
                end
            end
        end
        
        function x = my_ifft(X)
        % Calculate IFFT with recursion
        
            n = length(X); % Length of the input vector
        
            % If n <= 1, the function returns the input vector x as output 
            if n <= 1
               x = X;
            else
                % Spliting input into even and odd and another calling of function
                even = Transformations.my_ifft(X(1:2:end));
                odd = Transformations.my_ifft(X(2:2:end));
        
                % Inicialization of x
                x = zeros(1, n);
        
                % Combination of results
                for k = 1:n/2
                    t = exp(2i * pi * (k-1) / n) * odd(k);
                    x(k) = (even(k) + t) / 2;
                    x(k + n/2) = (even(k) - t) / 2;
                end
            end
        end
        
        function F = my_fft2(X)
        % Function for my FFT

            % Get the size of the matrix
            [rows, cols] = size(X);
            
            % initialization of output matrix
            F_complex = zeros(rows, cols);
        
            % Compute the FFT for each row
            for i = 1:rows
                F_complex(i, :) = Transformations.my_fft(X(i, :));
            end
        
            % Compute the FFT for each column
            for i = 1:cols
                F_complex(:, i) = Transformations.my_fft(F_complex(:, i));
            end
            F = F_complex;
        end
        
        function x = my_ifft2(X)
        % My FFT
        
            % Get the size of the matrix
            [rows, cols] = size(X);
            
            % initialization of output matrix
            x_complex = zeros(rows, cols);
        
            % Compute the IFFT for each column
            for c = 1:cols
                x_complex(:, c) = Transformations.my_ifft(X(:, c).');
            end
        
            % Compute the IFFT for each row
            for r = 1:rows
                x_complex(r, :) = Transformations.my_ifft(x_complex(r, :));
            end
        
            x = x_complex;
        end
    end
end
