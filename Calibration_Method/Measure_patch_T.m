function Measure_patch_T(T, color_array)
% Plots a number of color patches after computing the transformation over 
% input RGB values. The patches are shown with a delay of 0.5s. The
% purpose is to measure (device) the resulting patches after the
% transformation. 
%
% INPUTS:   T -> 3x3 matrix-based transformation
%           color_array -> RGB values
% OUTPUT:   Shows color patches with a delay of 0.5s 
%
% Author:   Maria-Jose Rueda - mariajoserdmnts@gmail.com

for i=1:length(color_array) 
    lin_rgb = rgb2lin(color_array(i,:));
    rgb_lin_T(:) = lin_rgb(:)' * T;
    rgb_T(:) = lin2rgb(rgb_lin_T);
    % Create the images
    patch = zeros(1000,1000,3);
    % Calculated rgb
    patch(:,:,1) = rgb_T(1,1)/255;
    patch(:,:,2) = rgb_T(1,2)/255;
    patch(:,:,3) = rgb_T(1,3)/255;
    Img = cat(3, patch(:,:,1), patch(:,:,2), patch(:,:,3));
    % Display the images
    set(gcf,'color',[0.65 0.65 0.65]) % background color 
    imshow(Img);
    % Delay between patches
    pause(0.5);
end
end