function F = myfft(x)
% Calculate FFT with recursion
    
    % Length of the input vector
     n = length(x);

    % If n <= 1, the function returns the input vector x as output F
    if  n <= 1
        F = x;
    else
        % Spliting input into even and odd and another calling of function
        even = myfft(x(1:2:end));
        odd = myfft(x(2:2:end));

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