function output = mydwt2(block)

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
