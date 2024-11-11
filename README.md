# 155YGEI Geoinformatics

## Description
This repository contains projects for the course **[155YGEI Geoinformatics](https://geo.fsv.cvut.cz/gwiki/155YGEI_Geoinformatika)**.

## Authors
#### Group 3
- **[Michal Kovář](https://github.com/kovarmi9)**
- **[Filip Roučka](https://github.com/fifi1ous)**
- **[Magdaléna Soukupová](https://github.com/soukupovam)**

## Repository Contents

### [U1 - JPEG Raster Compression](https://github.com/kovarmi9/YGEI_sk3/tree/main/U1)
#### [Assignment](https://github.com/k155cvut/ygei/blob/main/cviceni/geoinf_cv1.pdf)
This folder contains the implementation of the algorithms for JPEG compression and decompression of raster images in MATLAB. It includes the following steps and their inverse operations:
- Transformation from RGB to YCbCr
- Interval transformation
- Resampling of raster using 2X2 or Nearest Neigbour 
- Discrete Cosine Transform (DCT), Discrete Fourier Transform (DFT) or Discrete Wavelet Transform (DWT)
- Quantization of coefficients
- Conversion of pixels to ZIG-ZAG sequences
- Huffman coding
- Testing results on various types of rasters (grayscale, color) with different compression factors
- Evaluation of results

### [U2 - Automated Object Recognition in Maps](https://github.com/kovarmi9/YGEI_sk3/tree/main/U2)
#### [Assignment](https://maps.fsv.cvut.cz/~cajthaml/ygei/YGEI_cv3.pdf)
This folder contains the implementation of algorithms for automated object recognition in maps using MATLAB. The task is divided into two main parts:
#### Part A: Pattern Recognition in Müller’s Map of Bohemia
  - Interactive selection of templates as a search sample using the function [`select_samples`](https://github.com/kovarmi9/YGEI_sk3/tree/main/U2/A/select_samples.m) or using predefined templates
  - Calculation of an average template as the mean of the selected templates
  - Using the function [`process_image`](https://github.com/kovarmi9/YGEI_sk3/tree/main/U2/A/process_image.m) to convert the image to the Y channel of the YCbCr color space and applying a Gaussian kernel
  - Calculation of the correlation coefficient between the template and parts of the map using the MATLAB function [`normxcorr2`](https://www.mathworks.com/help/images/ref/normxcorr2.html)
  - Identification of locations with correlation values above the limit
  - Searching of all positions of villages with churches on the map
  - Filtering out duplicate positions using the function [`find_unique_positions`](https://github.com/kovarmi9/YGEI_sk3/tree/main/U2/A/find_unique_positions.m)
  - Displaying and printing the pixel coordinates

#### Part B: Image Segmentation Using k-Means
  - Edited input image
  - With function [`Segment_kmeans`](https://github.com/kovarmi9/YGEI_sk3/blob/main/U2/B/Segment_kmeans.m) input image is converted from RGB to CIA Labs by function [`makecform`](https://www.mathworks.com/help/images/ref/makecform.html) and [`applycform`](https://www.mathworks.com/help/images/ref/applycform.html). Clustering performed by k-means clustering function [`kmeans`](https://github.com/kovarmi9/YGEI_sk3/blob/main/U2/B/Segment_kmeans.m). For faster calculations results are saved into structure mfiles.
  - Function [`generate_bands`](https://github.com/kovarmi9/YGEI_sk3/blob/main/U2/B/generate_bands.m), creates variables with cluster band for faster and more automatic usage
  - Filtering and Computations with clustered images
  - Export of results
