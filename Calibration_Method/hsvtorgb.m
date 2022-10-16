function [Hue_rgb] = hsvtorgb(Hue_hsv)
% Convert HSV values into RGB (0-255)
% INPUTS:   Hue_hsv -> array with color values in HSV color space
% OUTPUTS:  Hue_rgb -> array with color values in RGB color space
%
% Author:   Maria-Jose Rueda - mariajoserdmnts@gmail.com
    Hue_hsv(:,2) = Hue_hsv(:,2)/100;
    Hue_hsv(:,3) = Hue_hsv(:,3)/100;
    Hue_hsv(:,1) = Hue_hsv(:,1)/360;
    Hue_rgb = hsv2rgb(Hue_hsv);
    Hue_rgb = round(Hue_rgb * 255);
end

