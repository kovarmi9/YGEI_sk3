function [Data_C,Data_L] = Segment_kmeans(img,nazevC,nazevL)
    % Convert the image to Lab color space
    cform = makecform('srgb2lab');
    lab_img = applycform(img, cform);
    
    % Extract the 'a' and 'b' channels (color information)
    ab = double(lab_img(:,:,2:3));
    nrows = size(ab, 1);
    ncols = size(ab, 2);
    ab = reshape(ab, nrows * ncols, 2);
    
    % Apply K-means clustering to segment colors
    nColors = 12; % Number of clusters 
    [cluster_idx] = kmeans(ab, nColors, 'distance', 'sqEuclidean', 'Replicates',10);
    
    % Reshape cluster indices to match image dimensions
    pixel_labels = reshape(cluster_idx, nrows, ncols);
    
    % Display each cluster to identify the green cluster visually
    
    Data_C={};
    Data_L={};
    for i = 1:nColors
        % Create a mask for each cluster
        cluster_mask = (pixel_labels == i);
        Data_L = [Data_L,cluster_mask];
        % Apply the mask to the original image
        Data_C = [Data_C,bsxfun(@times, img, cast(cluster_mask, 'like', img))];
    end
    save(nazevC+".mat", 'Data_C')
    save(nazevL+".mat", 'Data_L')
    Data_C=cell2struct({Data_C},'Data',1);
    Data_L=cell2struct({Data_L},'Data',1);
end