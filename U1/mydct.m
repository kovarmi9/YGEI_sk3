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