clc; clear variables; close all; format long g

% Load the image
im = imread('TM25_sk3_edit2.jpg');

NameC="Data_C";
NameL="Data_L";
t=0;

if ~exist(NameC+".mat",'file')|| ~exist(NameL+".mat",'file')
    [DataC,DataL] = Segment_kmeans(im,NameC,NameL);
    t=1;
else
    DataC1 = load(NameC+".mat");
    DataC.Data=DataC1.Data_C;
    DataL1 = load(NameL+".mat");
    DataL.Data=DataL1.Data_L;
end

for i=1:length(DataC.Data)
    figure(i)
    imshow(DataC.Data{i})
end

L=0;
[L] = generate_bands(t,L,"Les");
les=DataL.Data{L};
figure(20)
subplot(2, 3, 1);
imshow(les)
title('Les')

C=0;
[C] = generate_bands(t,C,"Cesta");
cesta=DataL.Data{C};
subplot(2, 3, 2);
imshow(cesta)
title('Cesta')

E=0;
[E] = generate_bands(t,E,"Extra");
extra=DataL.Data{E};
subplot(2, 3, 3);
imshow(extra)
title('Extra')

V=0;
[V] = generate_bands(t,V,"Voda");
voda=DataL.Data{V};
subplot(2, 3, 4);
imshow(voda)
title('Voda')

Vr=0;
[Vr] = generate_bands(t,Vr,"Vrstevnice");
vrstevnice=DataL.Data{Vr};
subplot(2, 3, 5);
imshow(vrstevnice)
title('Vrstevnice')

Lev=0;
[Lev] = generate_bands(t,Lev,"Leva");
leva=DataL.Data{Lev};
subplot(2, 3, 6);
imshow(leva)
title('Leva')



diskFilter = fspecial('disk', 5);
% Apply the disk filter using imfilter
les = imfilter(les, diskFilter, 'replicate');

les = imdilate(les, strel('square', 5));
figure(10)
imshow(les)


les=uint8(les);
imwrite(les, 'IMG_LES.jpg');
img_4band = cat(3, im, les);
imwrite(les, 'TM25_sk3_Result.jpg');

