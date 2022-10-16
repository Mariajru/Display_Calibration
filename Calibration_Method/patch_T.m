function [rgb_calc] = patch_T(T, P_hue)
% Displays a color patch after compute the matrix-based transformation T
% over input RGB values.
%
% INPUTS:   T -> 3x3 matrix-based transformation
%           P_hue_ref -> unique hue (red, green or blue) set of linear rgb 
%           responses
% OUTPUT:   Shows a color patch
%
% Author:   Maria-Jose Rueda - mariajoserdmnts@gmail.com

% Computes the transformation in the linear-RGB space
linrgb_calc = P_hue * T; 
% RGB values as output
rgb_calc = lin2rgb(linrgb_calc); 
end

