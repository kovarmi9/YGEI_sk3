function [NewImg] = MyDResample(MyImg,k)
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
            [r,s,b]=size(MyImg);    % Get parameters of a picture
            nS=s/k;                 % Get the step in colunms
            nR=r/k;                 % Get the step in rows
            NewImg=zeros(nS,nR,b);    % Creates an empty picture
        
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