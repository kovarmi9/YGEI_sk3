clc; clear; format long G

MyImg=randi(255,128,128,3);



% k=4;
% 
%     [r,s,b]=size(MyImg);    % Get parameters of a picture
%     nS=s/k;                 % Get the step in colunms
%     nR=r/k;                 % Get the step in rows
%     NewImg=zeros(nS,nR,b);    % Creates an empty picture
% 
%     %runs for each band
%     for n=1:b 
%         %runs for rows
%         for i=0:nR-1
%             %runs for colunms
%             for j=0:nS-1
% 
%                 NewImg(i+1,j+1,n)=MyImg(i*k+1,j*k+1,n); %generates new image
%             end
%         end
%     end


% k=2;
% [r,s,b]=size(MyImg);    % Get parameters of a picture
% nS=s*k;                 % Creates an empty picture
% nR=r*k;                 % Get the step in colunms
% NewImg=zeros(nR,nS,b);    % Get the step in rows
% 
% %runs for each band
% for n=1:b
%     %runs for rows
%     for i=0:r-1
%         %runs for colunms
%        for j=0:s-1
%            R_new_b=i*k+1;    % get the begining row of submatrix
%            R_new_e=i*k+k;   % get the end row of new submatrix
%            C_new_b=j*k+1;    % get the begining colunm of submatrix
%            C_new_e=j*k+k;   % get the end colunm of submatrix
%            NewImg(R_new_b:R_new_e,C_new_b:C_new_e,n)=MyImg(i+1,j+1,n);
%        end
%     end
% end

% k=2;
[r,s,b]=size(MyImg);    % Get parameters of a picture
nS=s/k;                 % Creates an empty picture
nR=r/k;                 % Get the step in colunms
NewImg=zeros(nR,nS,b);    % Get the step in rows

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


% MyImg=randi(255,18,18,3);

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
