clc; clear; format long G

MyImg=randi(255,128,128,3);



k=4;

[r,s,b]=size(MyImg);
NewImg=zeros(k,k,b);
nS=r/k;
nR=r/k;

for n=1:b    
    for i=0:k-1
        for j=0:k-1
            NewImg(i+1,j+1,n)=MyImg(i*nS+1,j*nR+1,n);
        end
    end
end