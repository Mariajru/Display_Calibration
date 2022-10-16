function [array_r_inv, array_g_inv, array_b_inv, array_o_inv, ...
    array_y_inv] = inverse_hue(array_r, array_g, array_b, array_o, array_y)
% Calculates the symmetrical angle with respect to the expected hue angle 
% in the HSV color space.
% INPUTS:   array_r_inv -> HSV values (hue, saturation, value)
%
% OUTPUTS:  array_r -> HSV new values (hue updated)
%
% Author:   Maria-Jose Rueda - mariajoserdmnts@gmail.com

    % Red hues
    array_r_inv = array_r;
    array_r_inv(:,1) = 360 - array_r(:,1);
    % Green hues
    array_g_inv = array_g;
    array_g_inv(:,1) = 120 + (120 - array_g(:,1));
    % Blue hues
    array_b_inv = array_b;
    array_b_inv(:,1) = 240 + (240 - array_b(:,1));
    % Orange hues
    array_o_inv = array_o;
    array_o_inv(:,1) = 30 + (30 - array_o(:,1));
    % Yellow hues
    array_y_inv = array_y;
    array_y_inv(:,1) = 60 + (60 - array_y(:,1));
    
end

