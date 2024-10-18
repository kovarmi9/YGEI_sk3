function block = myidwt2(LL)

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
