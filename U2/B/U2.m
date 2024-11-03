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
    impixelinfo
end

predel = 3150;
L=0;
[L] = generate_bands(t,L,"Les");
les=DataL.Data{L};

L1=0;
[L1] = generate_bands(t,L1,"Les1");
les1=DataL.Data{L1};

C=0;
[C] = generate_bands(t,C,"Cesta");
cesta=DataL.Data{C};

C2=0;
[C2] = generate_bands(t,C2,"Cesta2");
cesta2=DataL.Data{C2};


E=0;
[E] = generate_bands(t,E,"Extra");
extra=DataL.Data{E};

V=0;
[V] = generate_bands(t,V,"Voda");
voda=DataL.Data{V};

VrIn=0;
[Vr_in] = generate_bands(t,VrIn,"VrstevniceIn");
vrstevniceIn=DataL.Data{Vr_in};

VrOt=0;
[Vr_ot] = generate_bands(t,VrOt,"VrstevniceOt");
vrstevniceOt=DataL.Data{Vr_ot};

CestaIn=0;
[CestaIn] = generate_bands(t,CestaIn,"CestaIn");
CestaIn=DataL.Data{CestaIn};



diskFilter = fspecial('disk', 5);
les1 = imfilter(les1, diskFilter, 'replicate');

les = les | les1;
les = les | vrstevniceIn;
les = les & ~vrstevniceOt;
les = les & ~voda;
les = les & ~CestaIn;
les = les & ~cesta;

diskFilter = fspecial('disk', 5);
les = imfilter(les, diskFilter, 'replicate');
figure(20)
imshow(les);

les = uint8(les); 
les = les * 255;  
imwrite(les, 'IMG_LES.tif');

img_4band = cat(3, im, les); 

imwrite(img_4band, 'TM25_sk3_Result.tif');