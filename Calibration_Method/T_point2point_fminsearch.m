%% Unconstrained nonlinear optimisation
% Computes the transformation T_final which maps the linear reference-RGB 
% points into the linear user-RGB points. This transformation is computed 
% finding the minimum of unconstrained multivariable function using 
% derivative-free method from point to point. 
%
% Author:   Maria-Jose Rueda - mariajoserdmnts@gmail.com

%% Transform the data

% Reference hue selections
% Calculate the symmetrical hue angle
[R_hsv_inv, G_hsv_inv, B_hsv_inv, O_hsv_inv, Y_hsv_inv] = ... 
    inverse_hue(R_hsv, G_hsv, B_hsv, O_hsv, Y_hsv);
% Change into RGB color space
R_rgb_p = hsvtorgb(R_hsv_inv);
G_rgb_p = hsvtorgb(G_hsv_inv);
B_rgb_p = hsvtorgb(B_hsv_inv);
Y_rgb_p = hsvtorgb(Y_hsv_inv);
O_rgb_p = hsvtorgb(O_hsv_inv);
% Change to linear-RGB
R_p = rgb2lin(R_rgb_p);
G_p = rgb2lin(G_rgb_p);
B_p = rgb2lin(B_rgb_p);
Y_p = rgb2lin(Y_rgb_p);
O_p = rgb2lin(O_rgb_p);
P_ref_inv = [R_p; G_p; B_p];

% User hue selections
% Calculate the symmetrical hue angle
[R_hsv_inv2, G_hsv_inv2, B_hsv_inv2, O_hsv_inv2, Y_hsv_inv2] = ... 
    inverse_hue(R_hsv2, G_hsv2, B_hsv2, O_hsv2, Y_hsv2);
% Change into RGB color space
R_rgb_p2 = hsvtorgb(R_hsv_inv2);
G_rgb_p2 = hsvtorgb(G_hsv_inv2);
B_rgb_p2 = hsvtorgb(B_hsv_inv2);
Y_rgb_p2 = hsvtorgb(Y_hsv_inv2);
O_rgb_p2 = hsvtorgb(O_hsv_inv2);
% Change to linear-RGB
R_p2 = rgb2lin(R_rgb_p2);
G_p2 = rgb2lin(G_rgb_p2);
B_p2 = rgb2lin(B_rgb_p2);
Y_p2 = rgb2lin(Y_rgb_p2);
O_p2 = rgb2lin(O_rgb_p2);
P_user_inv = [R_p2; G_p2; B_p2];

%% fminsearch optimization
% fminsearch parameters
options = optimset;
% Initial points
T = [1,0,0; 0,1,0; 0,0,1];
% Minimization in the linear-RGB space
T_final_point = fminsearch(@T_rms_err, T, options, P_ref_inv, P_user_inv);

%% Plot the images before and after the transformation 
% Computes the new image with the T optimized
dim = size(I);
lin_RGB = I(:,:,:);
lin_RGB = rgb2lin(lin_RGB);
rgb = zeros(1,3);
I_optimized = I;
for y = 1:dim(2)
    for x = 1:dim(1)
        rgb(:) = lin_RGB(x, y, :);
        I_optimized(x,y,:) =  rgb * T_final_point;
    end
end
% Transform the new image into rgb values
I_optimized = lin2rgb(I_optimized);
figure('Name', 'Point-Point fminsearch RGB'); 
imshow(I_optimized, 'InitialMagnification', 'fit');

%% Display the colors from an RGB input
% Apply T to user for user to math the ref display
rgb_T = patch_T(T_final_point, P_u);
% Change into linear-RGB
rgb_calc = lin2rgb(P_ref_inv); 

[Img_point2point_T] = patch_imshow(rgb_T, 'Point-Point fminsearch');
[Img_point2point_calc] = patch_imshow(rgb_calc, 'Point-Point calc');

%% ------------------------FUNTIONS----------------------------------------
function [err] = T_rms_err(T, lin_rgb_ref, lin_rgb_user)
% Computes the predicted user lin-RGB values by applying the transformation 
% to the reference lin-RGB values. The error is calculated between the
% predicted values and the ideal value: 
% linear-RGB user = linear-RGB reference
% 
% INPUTS:   T -> 3x3 matrix-based transformation
%           lin_rgb_ref -> unique hue set of linear-RGB responses in the
%           reference display
%           lin_rgb_user -> unique hue set of linear-RGB responses in the
%           user display
% OUTPUTS:  err -> RMS error

pre_rgb = zeros(18,3);
for i=1:6
    % Predicted lin-rgb user values
    pre_rgb(i,:) = lin_rgb_user(i,:) * T;
end
% Force to be a row matrix
pre = pre_rgb(:)';
rgb = lin_rgb_ref(:)'; 
% Compute RMS error
err = sqrt((sum((rgb-pre).*(rgb-pre)))/length(rgb));
end