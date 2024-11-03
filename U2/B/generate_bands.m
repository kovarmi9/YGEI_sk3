function [L] = generate_bands(t,L,Nazev)
    folderName = "Bands";

    if ~exist(folderName,'dir')
        mkdir(folderName);
    end

    if t
        while true
            L=input('Please enter a numeric value 1-12: ', 's');
            L=str2double(L);
    
            if ~isnan(L) &&  L>0 && L<13
                break
            else
                disp('Invalid input. Please enter a numeric value [1-12]');
            end
        end
        save(folderName+"/"+Nazev,'L')
    else
        L=load(folderName+"/"+Nazev);
        L= struct2cell(L);
        L= cell2mat(L);
    end
end