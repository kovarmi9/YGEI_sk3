function [L] = generate_bands(t,L,Nazev)
    folderName = "Bands";

    if ~exist(folderName,'dir')
        mkdir(folderName);
    end

    if t
        while true
            L=input('Please enter a numeric value 1-6: ', 's');
            L=str2double(L);
    
            if ~isnan(L) &&  L>0 && L<8
                break
            else
                disp('Invalid input. Please enter a numeric value [1-6]');
            end
        end
        save(folderName+"/"+Nazev,'L')
    else
        L=load(folderName+"/"+Nazev);
        L= struct2cell(L);
        L= cell2mat(L);
    end
end