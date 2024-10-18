function [NewImg] = MyUResample(MyImg,k)
            %%
            % up resampeling - Nearest Neigbour
            % input = MyImg - images
            %           k   - resampeling factor factor if not used se to 2
            %                 (use even numbers)
            %
            % output = NewImg - resampled image
            %%
            if nargin <2
                k=2;
            end
            [r,s,b]=size(MyImg);    % Get parameters of a picture
            nS=s*k;                 % Creates an empty picture
            nR=r*k;                 % Get the step in colunms
            NewImg=zeros(nR,nS,b);    % Get the step in rows
            
            %runs for each band
            for n=1:b
                %runs for rows
                for i=0:r-1
                    %runs for colunms
                   for j=0:s-1
                       R_new_b=i*k+1;    % get the begining row of submatrix
                       R_new_e=i*k+k;   % get the end row of new submatrix
                       C_new_b=j*k+1;    % get the begining colunm of submatrix
                       C_new_e=j*k+k;   % get the end colunm of submatrix
                       NewImg(R_new_b:R_new_e,C_new_b:C_new_e,n)=MyImg(i+1,j+1,n);
                   end
                end
            end
        end