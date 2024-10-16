clc; clear; format long G

MyImg=randi(255,8,8,3);


[r,~,b]=size(MyImg);
k=128;
nS=k/r;
nR=k/r;

NewImg=zeros(k,k,b);
for n=1:b
    for i=0:r-1
       for j=0:r-1
           NewImg(i*nR+1:i*nR+nR,j*nS+1:j*nS+nS,n)=MyImg(i+1,j+1,n);
       end
    end
end


% for n=1:b    
%     for i=0:k-1
%         for j=0:k-1
%             NewImg(i+1,j+1,n)=MyImg(i*nS+1,j*nR+1,n);
%         end
%     end
% end