function F = myfft2(X)

    % Get the size of the matrix
    [rows, cols] = size(X);
    
    % initialization of output matrix
    F_complex = zeros(rows, cols);

    % Compute the FFT for each row
    for i = 1:rows
        F_complex(i, :) = fft(X(i, :));
    end

    % Compute the FFT for each column
    for i = 1:cols
        F_complex(:, i) = fft(F_complex(:, i));
    end
    F = F_complex;
end