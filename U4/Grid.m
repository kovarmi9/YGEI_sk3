function T = Grid(CN,M)
    MinX = min(M(:,1));
    MinY = min(M(:,2));
    MaxX = max(M(:,1));
    MaxY = max(M(:,2));
    Y = MaxY - MinY;
    X = MaxX - MinX;
    
    CN2 = CN;
    if rem((CN - floor(sqrt(CN))^2)/floor(sqrt(CN)),1) ~= 0
        if (CN - floor(sqrt(CN))^2) -  floor(sqrt(CN)) <0
            Addition = (CN - floor(sqrt(CN))^2);
        else
            Addition = (CN - floor(sqrt(CN))^2) -  floor(sqrt(CN));
        end
        CN = CN - Addition;
        Pom = ones(Addition,1);
    end
    H = CN/floor(sqrt(CN));
    V = CN/H;
    
    Xt = [];
    Yt = [];
    
    XT = MinX : X/H : MaxX;
    YT = MinY : Y/V : MaxY;
    for i=1:H
        Xt = [Xt;(XT(i)+XT(i+1))/2];
    end
    for i=1:V
        Yt = [Yt;(YT(i)+YT(i+1))/2];
    end
    T = [];
    for i = 1 : H
        for j = 1:V
            T = [T;Xt(i),Yt(j)];
        end
    end
    % if CN2 ~=CN
    %     if rem(floor(sqrt(CN)),2)
    %         if (CN - floor(sqrt(CN))^2) -  floor(sqrt(CN)) <0
    %             T2 = [];
    %            Xmmin = min(T(:,1));
    %            Ymmin = min(T(:,2));
    %            for n=1:2:(Addition*2)
    %                XM = Xmmin + (X/H)/2*n;
    %                YM = Ymmin + (Y/V)/2*n;
    %                T2 = [T2;XM,YM];
    %            end
    %
    %         else
    %
    %            Xm = mean(T(:,1));
    %            Ymmin = min(T(:,2));
    %            Ymmax = max(T(:,2));
    %            Ym =  ((Ymmax-Ymmin)/(Addition+1));
    %            YM = zeros(Addition,1);
    %            for n=1:Addition
    %                YM(n) = Ymmin + Ym*n;
    %            end
    %            T2 = [Xm .* Pom, YM];
    %         end
    %     else
    %         if (CN - floor(sqrt(CN))^2) -  floor(sqrt(CN)) <0
    %            T2 = [];
    %            Xmmin = min(T(:,1));
    %            Ymmin = min(T(:,2));
    %            for n=1:2:(Addition*2)
    %                XM = Xmmin + (X/H)/2*n;
    %                YM = Ymmin + (Y/V)/2*n;
    %                T2 = [T2;XM,YM];
    %            end
    %         else
    %            Ym = mean(T(:,2));
    %            Xmmin = min(T(:,1));
    %            Xmmax = max(T(:,1));
    %            Xm =  ((Xmmax-Xmmin)/(Addition+1));
    %            XM = zeros(Addition,1);
    %            for n=1:Addition
    %                XM(n) = Xmmin + Xm*n;
    %            end
    %            T2 = [XM, Ym .* Pom];
    %         end
    %     end
    %     T = [T;T2];
    % end
    if CN2 ~=CN
        if (CN - floor(sqrt(CN))^2) -  floor(sqrt(CN)) <0
           T2 = [];
           Xmmin = min(T(:,1));
           Ymmin = min(T(:,2));
           for n=1:2:(Addition*2)
               XM = Xmmin + (X/H)/2*n;
               YM = Ymmin + (Y/V)/2*n;
               T2 = [T2;XM,YM];
           end
        else
            if rem(floor(sqrt(CN)),2)
               Xm = mean(T(:,1));
               Ymmin = min(T(:,2));
               Ymmax = max(T(:,2));
               Ym =  ((Ymmax-Ymmin)/(Addition+1));
               YM = zeros(Addition,1);
               for n=1:Addition
                   YM(n) = Ymmin + Ym*n;
               end
               T2 = [Xm .* Pom, YM];
            else
               Ym = mean(T(:,2));
               Xmmin = min(T(:,1));
               Xmmax = max(T(:,1));
               Xm =  ((Xmmax-Xmmin)/(Addition+1));
               XM = zeros(Addition,1);
               for n=1:Addition
                   XM(n) = Xmmin + Xm*n;
               end
               T2 = [XM, Ym .* Pom];
            end
        end
        T = [T;T2];
    end
end