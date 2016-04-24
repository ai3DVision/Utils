function [img_out] = MNIST_resize(img, long_border_roi_resize, height_out, width_out)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform MNIST style resize for simple images (e.g., binary digits)
% Input:
%       img: input image, should be gray scale (background = 0, ROI > 0)
%       long_border_roi_resize: long-border size of ROI after resized
%       height_out: height of output image
%       width_out: width of output image
%
% Output:
%       img_out: output image
%
%   Conan
%   2016.4.24
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if long_border_roi_resize >= max(height_out, width_out)
    error('Long-border of ROI should not exceed the long-border of image!');
end

if ndims(img) ~= 2
    error('Input image should be gray scale!');
end

[height, width] = size(img);
[row_img, col_img] = find(img > 0);

% compute ROI coordinates
x0 = min(col_img);
y0 = min(row_img);
roi_height = max(row_img) - y0 + 1;
roi_width  = max(col_img) - x0 + 1;

% compute center of mass
[py, px] = ndgrid(1:height, 1:width);
center_x = round(mean(px(logical(img))));
center_y = round(mean(py(logical(img))));

% shift image
img_center = zeros(size(img));
dx = center_x - x0 + 1;
dy = center_y - y0 + 1;
x = max(floor(width / 2) - dx, 1);
y = max(floor(height / 2) - dy, 1);
img_center(y : y + roi_height - 1, x : x + roi_width - 1) =  ...
    img(y0 : y0 + roi_height - 1, x0 : x0 + roi_width - 1 );

% resize image
long_border = max(roi_height, roi_width);
resize_ratio = long_border_roi_resize / long_border;
img_small = imresize(img_center, resize_ratio);

% shift to the output grid
img_out = zeros(height_out, width_out);
[height, width] = size(img_small);
roi_height_small = floor(roi_height * resize_ratio);
roi_width_small = floor(roi_width * resize_ratio);
y0 = max(floor(height / 2 - roi_height_small / 2), 1);
x0 = max(floor(width / 2 - roi_width_small / 2), 1);
y = max(floor(height_out / 2 - roi_height_small / 2), 1);
x = max(floor(width_out / 2 - roi_width_small / 2), 1);

img_out(y : y + roi_height_small - 1, x : x + roi_width_small - 1) =  ...
    img_small(y0 : y0 + roi_height_small - 1, x0 : x0 + roi_width_small - 1 );
