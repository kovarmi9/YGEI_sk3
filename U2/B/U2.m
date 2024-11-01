clc; clear variables; close all; format long g

% Load the image
im = imread('TM25_sk3_edit.jpg');

NameC="Data_C";
NameL="Data_L";

if ~exist(NameC+".mat",'file')|| ~exist(NameL+".mat",'file')
    [Data_C,Data_L] = Segment_kmeans(im,NameC,NameL);
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

L=2;
V=4;
C=6;

les=DataL.Data{L};
voda=DataL.Data{V};
cesta=DataL.Data{C};


% les =  double(les) - double(cesta);
% les(les<0)=0;


% lowPassFilter = fspecial('gaussian', 5 ,3);
% 
% % Apply the filter using convolution
% les2 = imfilter(les, lowPassFilter);

diskFilter = fspecial('disk', 5);

% Apply the disk filter using imfilter
les2 = imfilter(les, diskFilter, 'replicate');

lowPassFilter = fspecial('gaussian', 5 ,1);

% Apply the filter using convolution
les2 = imfilter(les2, lowPassFilter);
% 
% % lowPassFilter = fspecial('gaussian', 5 ,5);
% % 
% % % Apply the filter using convolution
% % les2 = imfilter(les2, lowPassFilter);




figure(10)
imshow(logical(les))

figure(11)
imshow(logical(les2))




