function x = myifft2(X)

    % Get the size of the matrix
    [rows, cols] = size(X);
    
    % initialization of output matrix
    x_complex = zeros(rows, cols);

    % Compute the IFFT for each column
    for c = 1:cols
        x_complex(:, c) = myifft(X(:, c).');
    end

    % Compute the IFFT for each row
    for r = 1:rows
        x_complex(r, :) = myifft(x_complex(r, :));
    end

    x = x_complex;
end

function x = myifft(X)
    % MYIFFT Computes the Inverse Fast Fourier Transform (IFFT) of the input vector X.
    %   x = MYIFFT(X) takes a vector X as input and returns the IFFT of X.
    %
    %   Example:
    %       X = [1, 2, 3, 4];
    %       x = myifft(X);
    %       disp(x);

    N = length(X); % Length of the input vector

    if N <= 1
        x = X;
    else
        % Split the input into even and odd indexed elements
        even = myifft(X(1:2:end));
        odd = myifft(X(2:2:end));

        % Combine the results
        x = zeros(1, N);
        for k = 1:N/2
            t = exp(2i * pi * (k-1) / N) * odd(k);
            x(k) = (even(k) + t) / 2;
            x(k + N/2) = (even(k) - t) / 2;
        end
    end
end
