function [NewImg] = MyUResample(MyImg,k)
%%
% up resampeling
% input = MyImg - images
%           k   - resampeling factor factor
%
% output = NewImg - resampled image
%%   
    [r,~,b]=size(MyImg);        % Get parameters of a picture
    NewImg=zeros(k,k,b);        % Creates an empty picture
    nS=k/r;                     % Get the step in colunms
    nR=k/r;                     % Get the step in rows
    

    for n=1:b
        for i=0:r-1
           for j=0:r-1
               R_new_b=i*nR+1;    % get the begining row of submatrix
               R_new_e=i*nR+nR;   % get the end row of new submatrix
               C_new_b=j*nS+1;    % get the begining colunm of submatrix
               C_new_e=j*nS+nS;   % get the end colunm of submatrix
               NewImg(R_new_b:R_new_e,C_new_b:C_new_e,n)=MyImg(i+1,j+1,n);
           end
        end
    end
end