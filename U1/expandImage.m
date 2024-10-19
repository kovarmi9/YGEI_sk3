function [expandedImg] = expandImage(originalImg, newImg)
    [orig_r, orig_s, b] = size(originalImg);
    [new_r, new_s, ~] = size(newImg);
    scale_factor_r = orig_r / new_r;
    scale_factor_s = orig_s / new_s;
    
    expandedImg = zeros(orig_r, orig_s, b);

    for n = 1:b
        for i = 1:new_r
            for j = 1:new_s
                expandedImg((i-1)*scale_factor_r+1:i*scale_factor_r, (j-1)*scale_factor_s+1:j*scale_factor_s, n) = newImg(i, j, n);
            end
        end
    end
end