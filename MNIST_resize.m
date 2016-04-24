function [img_out] = MNIST_resize(img, long_border_roi_resize, height_out, width_out)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform a MNIST style resize for simple images (e.g., binary digits)
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

[row_img, col_img] = find(img > 0);
long_border = max(max(row_img) - min(row_img) + 1, max(col_img) - min(col_img) + 1);
resize_ratio = long_border_roi_resize / long_border;
img_small = imresize(img, resize_ratio);

% centerized image
[row_img_small, col_img_small] = find(img_small > 0);
x0 = min(col_img_small);
y0 = min(row_img_small);
roi_height = max(row_img_small) - y0 + 1;
roi_width  = max(col_img_small) - x0 + 1;

[py, px] = ndgrid(1:size(img_small,1), 1:size(img_small,2));            
center_x = round(mean(px(logical(img_small))));
center_y = round(mean(py(logical(img_small))));
dx = center_x - x0 + 1;
dy = center_y - y0 + 1;

img_out = zeros(height_out, width_out);
x = max(floor(width_out / 2) - dx, 1);
y = max(floor(height_out / 2) - dy, 1);
img_out(y : y + roi_height - 1, x : x + roi_width - 1) =  ...
    img_small(y0 : y0 + roi_height - 1, x0 : x0 + roi_width - 1 );
