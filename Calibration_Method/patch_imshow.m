function [Img] = patch_imshow(rgb, text)
% Displays a color patch given RGB as input. 
%
% INPUTS:   rgb -> RGB values
%           text -> figure title
% OUTPUT:   Shows a color patch
%
% Author:   Maria-Jose Rueda - mariajoserdmnts@gmail.com

% Create the images
unique_hue = zeros(400,400,3);
% Calculated rgb
unique_hue(:,:,1) = rgb(1,1)/255;
unique_hue(:,:,2) = rgb(1,2)/255;
unique_hue(:,:,3) = rgb(1,3)/255;
Img = cat(3, unique_hue(:,:,1), unique_hue(:,:,2), unique_hue(:,:,3));
% Display the images
figure('Name', text); 
set(gcf,'color',[0.65 0.65 0.65]); % background color 
imshow(Img);
end