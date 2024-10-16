clc; clear; format long G

MyImg=randi(255,8,8,3);
k=2;

[r,s,b]=size(MyImg);    % Get parameters of a picture
nS=s*k;                 % Creates an empty picture
nR=r*k;                 % Get the step in colunms
NewImg=zeros(nR,nS,b);  % Get the step in rows

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
