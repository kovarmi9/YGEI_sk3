function [NewImg] = MydResample(MyImg,k)
%%
% input = MyImg - images
%           k   - resampeling factor factor
%
% output = NewImg - resampled image
%%   
    [r,~,b]=size(MyImg);    % Get parameters of a picture
    NewImg=zeros(k,k,b);    % Creates an empty picture
    nS=r/k;                 % Get the step in colunms
    nR=r/k;                 % Get the step in rows
    
    %runs for each band
    for n=1:b 
        %runs for rows
        for i=0:k-1
            %runs for colunms
            for j=0:k-1
                NewImg(i+1,j+1,n)=MyImg(i*nS+1,j*nR+1,n); %generates new image
            end
        end
    end
end