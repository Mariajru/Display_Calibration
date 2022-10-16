function Measure_patch(color_array)
% Plots a number of color patches given their input RGB values. The patches 
% are shown with a delay of 0.5s. The purpose is to measure (device) the
% color values of each patch. 
%
% INPUTS:   color_array -> RGB values
% OUTPUT:   Shows color patches with a delay of 0.5s 
%
% Author:   Maria-Jose Rueda - mariajoserdmnts@gmail.com

% Plot the rgb values from color_array
for i=1:length(color_array)
    rgb(1,1) = color_array(i,1);
    rgb(1,2) = color_array(i,2);
    rgb(1,3) = color_array(i,3);
    % Create the images
    patch = zeros(1000,1000,3);
    % Calculated rgb
    patch(:,:,1) = rgb(1,1)/255;
    patch(:,:,2) = rgb(1,2)/255;
    patch(:,:,3) = rgb(1,3)/255;
    Img = cat(3, patch(:,:,1), patch(:,:,2), patch(:,:,3));
    % Display the images
    set(gcf,'color',[0.65 0.65 0.65]) % background color 
    imshow(Img);
    % Delay between patches
    pause(0.5);
end
end