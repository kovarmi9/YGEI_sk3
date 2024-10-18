classdef Resample
    %   Resample Class for Resampeling square matrix 
    %
    %   Methods:
    %       MyDResampleNN  - down resampeling with Nearest Neigbour
    %       MyUResampleNN  - up resampeling with Nearest Neigbour
    %       MyDResample2X2 - down resampeling by kernel [2x2]
    %       MyDResample3X3 - down resampeling by kernel [3x3]
    %       MyUResample2X3 - up resampeling by kernel [2x2]
    methods (Static)
        function [NewImg] = MyDResampleNN(MyImg,k)
            %%
            % down resampeling - Nearest Neigbour
            % input = MyImg - images
            %           k   - resampeling factor factor if not used se to 2
            %                 (use even numbers)
            %
            % output = NewImg - resampled image
            %%  
            if nargin <2
                k=2;
            end
            [NewImg,nR,nS,~,~,b]=StatsDown(MyImg,k);
        
            %runs for each band
            for n=1:b 
                %runs for rows
                for i=0:nR-1
                    %runs for colunms
                    for j=0:nS-1
        
                        NewImg(i+1,j+1,n)=MyImg(i*k+1,j*k+1,n); %generates new image
                    end
                end
            end
        end

        function [NewImg] = MyUResampleNN(MyImg,k)
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
            [NewImg,~,~,r,s,b]=StatsUp(MyImg,k);
            
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

        function [NewImg] = MyDResample2X2(MyImg,k)
            %%
            % down resampeling - by kernel [kxk]
            % input = MyImg - images
            %           k   - resampeling factor factor if not used se to 2
            %                 (use even numbers)
            %
            % output = NewImg - resampled image
            %%
            if nargin <2
                k=2;
            end
            [NewImg,nR,nS,~,~,b]=StatsDown(MyImg,k);
            
            %runs for each band
            for n=1:b
                %runs for rows
                for i=0:nR-1
                    %runs for colunm
                    for j=0:nS-1
                        SubMatrix=MyImg(i*k+1:i*k+k,j*k+1:j*k+k,n); % creates submatrix [2x2]
                        NewImg(i+1,j+1,n)=round(sum(sum(SubMatrix))/(k^2)); % mean of the submatrix
                    end
                end
            end
        end

        function [NewImg] = MyDResample3X3(MyImg)
            %%
            % down resampeling - by kernel [3x3]
            % input = MyImg - images
            %
            % output = NewImg - resampled image
            %%
            [r,s,b]=size(MyImg);    % Get parameters of a picture
            if mod(r,3)             % Check if the image is devidable by 3
                num=3-mod(r,3);     % If not give back number that will make the number devidable by 3
            else
                num=0;              % If not return 0
            end
            PaddingR=ones(r,num);   % Creates padding
            PaddingC=ones(num,s);   
            Extra=ones(num,num); 
            
            nS=(s+num)/3;                 % Creates an empty picture
            nR=(r+num)/3;                 % Get the step in colunms
            NewImg=zeros(nR,nS,b);        % Get the step in rows
            
            %runs for each band
            for n=1:b
                MyImgPad=[MyImg(:,:,n),PaddingR.*MyImg(:,end,n);PaddingC.*MyImg(end,:,n),Extra*MyImg(end,end,n)]; % creates a matrix with padding
                %runs for rows
                for i=0:nR-1
                    %runs for colunm
                    for j=0:nS-1
                        SubMatrix=MyImgPad(i*3+1:i*3+3,j*3+1:j*3+3);    % creates submatrix [3x3]
                        NewImg(i+1,j+1,n)=round(sum(sum(SubMatrix))/9); % mean of the submatrix
                    end
                end
            end
        end

        function [NewImg] = MyUResample2X2(MyImg)
            %%
            % up resampeling - by kernel [2x2]
            % input = MyImg - images
            %
            % output = NewImg - resampled image
            %%
            k=2;
            [NewImg,~,~,r,s,b]=StatsUp(MyImg,k);
            
            % creates a padded matrix
            MyImgP=[MyImg,MyImg(:,end,:);MyImg(end,:,:),MyImg(end,end,:)];
            
            %runs for each band
            for n=1:b
                %runs for rows
                for i=0:r-1
                    %runs for colunm
                    for j=0:s-1
                        SubMatrixImg=MyImgP(i+1:i+k,j+1:j+k,n);     % creates submatrix [2x2]
                        % Interpolates values of the new matrix
                        SubMatrix=[SubMatrixImg(1),(SubMatrixImg(1)+SubMatrixImg(3))/2;(SubMatrixImg(1)+SubMatrixImg(2))/2,(SubMatrixImg(1)+SubMatrixImg(4))/2];
                        R_new_b=i*k+1;   % get the begining row of submatrix
                        R_new_e=i*k+k;   % get the end row of new submatrix
                        C_new_b=j*k+1;   % get the begining colunm of submatrix
                        C_new_e=j*k+k;   % get the end colunm of submatrix
                        NewImg(R_new_b:R_new_e,C_new_b:C_new_e,n)=round(SubMatrix);
                    end
                end
            end
        end
    end

    methods (Static, Access = private)
        function [NewImg,nR,nS,r,s,b]=StatsDown(MyImg,k)
            [r,s,b]=size(MyImg);      % Get parameters of a picture
            nS=s/k;                   % Creates an empty picture
            nR=r/k;                   % Get the step in colunms
            NewImg=zeros(nR,nS,b);    % Get the step in rows
        end

        function [NewImg,nR,nS,r,s,b]=StatsUp(MyImg,k)
            [r,s,b]=size(MyImg);     % Get parameters of a picture
            nS=s*k;                  % Creates an empty picture
            nR=r*k;                  % Get the step in colunms
            NewImg=zeros(nR,nS,b);    % Get the step in rows
        end

    end
end