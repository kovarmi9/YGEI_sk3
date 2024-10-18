function x = myifft(X)
% Calculate IFFT with recursion

    n = length(X); % Length of the input vector

    % If n <= 1, the function returns the input vector x as output 
    if n <= 1
       x = X;
    else
        % Spliting input into even and odd and another calling of function
        even = myifft(X(1:2:end));
        odd = myifft(X(2:2:end));

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
