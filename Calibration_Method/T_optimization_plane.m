%% Constrained optimisation
% Computes the transformation T_final which maps the linear reference-RGB 
% points into their correspondent hue planes in the linear user-RGB space.
% The transformation is obtained minimizing the distance between
% the linear reference-RGB points and the hue planes in the linear user-RGB 
% space by performing a constrained optimization. 
%
% Author:   Maria-Jose Rueda - mariajoserdmnts@gmail.com

% Paramters inicialization
x0 = rand(3,3);
A = []; 
b = [];
lb = [];
ub = [];
% First constraint: each row has to sum 1
Aeq = [1,0,0,1,0,0,1,0,0; 0,1,0,0,1,0,0,1,0; 0,0,1,0,0,1,0,0,1];
beq = [1;1;1];
% Minimization
T_final_plane = fmincon(@(x)T_point2plane(x, P_ref, n_User), x0, ...
    A,b,Aeq,beq,lb,ub, @(x)nonlcon(x,P_ref));

%% Plot the images before and after the transformation 
% Compute the new image with the T optimized 
dim = size(I);
lin_RGB = I(:,:,:);
lin_RGB = rgb2lin(lin_RGB);
rgb = zeros(1,3);
I_optimized = I;
for y = 1:dim(2)
    for x = 1:dim(1)
        rgb(:) = lin_RGB(x, y, :);
        I_optimized(x,y,:) =  rgb * T_final_plane;
    end
end
% Transform the new image into rgb values
I_optimized = lin2rgb(I_optimized);
figure('Name', 'Point-Plane RGB'); imshow(I_optimized, ...
    'InitialMagnification', 'fit');

%% Display the colors from an RGB input
rgb_plane = point2plane(P_user, n_R);
rgb_plane_T = point2plane_T(T_final_plane, P_u); 

[Img_point2plane] = patch_imshow(rgb_plane, ...
    'Point-Plane calc (User display)');
[Img_point2plane_T] = patch_imshow(rgb_plane_T, ...
    'Point-Plane T (User display)');

%% ----------------------------CONSTRAINS----------------------------------
function [err] = T_point2plane(x, P_ref, n_User)
% Computes the predicted user lin-RGB values by applying the transformation 
% to the reference lin-RGB values. The error is calculated between the
% predicted values and the ideal value (0 distance from the point to the
% plane).
% 
% INPUTS:   P_ref -> unique hue (red, green or blue) set of linear rgb 
%           responses
%           T -> 3x3 matrix-based transformation
%           n_User -> normals of the planes in the user display for the
%           input unique hue
% OUTPUTS:  err -> RMS error

T = [x(1), x(4), x(7);x(2), x(5), x(8);x(3), x(6), x(9)];
size_points = length(P_ref);
dist = zeros(1,size_points);
for i=1:size_points
    if i>=1 && i<=6
        N = n_User(1,:);
    elseif i>=7 && i <=12
        N = n_User(2,:);
    elseif i>=13 && i<=18
        N = n_User(3,:);
    end
    dist(i) = abs(P_ref(i,:) * T * N'); 
end
actual = zeros(1, length(dist));
pre = dist;
% Compute RMS error from the predicted result to 0
err = sqrt((sum((actual-pre).*(actual-pre)))/length(actual));
end

%% ------------------------------------------------------------------------
function [c, ceq] = nonlcon(x, P_ref)
% After the transformation the highest saturation value have to be
% preserved (HSV color space).
%
% INPUTS:   P_hue_ref -> unique hue (red, green or blue) set of linear rgb 
%           responses
% OUTPUTS:  c, ceq -> constraints 
%
% T = [x(1), x(4), x(7); x(2), x(5), x(8); x(3), x(6), x(9)];
% The diagonal because RGB, red is in x(1),  green is in x(5) and blue is 
% in x(9) (255,0,0) (0,255,0) (0,0,255)

c = [];
red = P_ref(1,1);
green = P_ref(7,2);
blue = P_ref(13,3);
ceq(1) = red * x(1) - red;
ceq(2) = green * x(5) - green;
ceq(3) = blue * x(9) - blue;
end

%% ------------------------FUNTIONS----------------------------------------
function [rgb_exp] = point2plane(P_hue_ref, n_hue_User)
% Maps the point to the plane using the mathematical formula
% 
% INPUTS:   P_hue_ref -> unique hue (red, green or blue) set of linear rgb 
%           responses
%           n_hue_User -> normals of the plane in the user display for the
%           input unique
% OUTPUTS:  rgb_exp -> rgb mapped values

dist = abs(P_hue_ref * n_hue_User'); 
linrgb_exp = P_hue_ref - dist * n_hue_User;
rgb_exp = lin2rgb(linrgb_exp);
end

function [rgb_calc] = point2plane_T(T, P_hue_ref)
% Maps the point to the plane using the matrix-based transformation
% 
% INPUTS:   P_hue_ref -> unique hue (red, green or blue) set of linear rgb 
%           responses
%           T -> 3x3 matrix-based transformation
% OUTPUTS:  rgb_exp -> rgb mapped values

linrgb_calc = P_hue_ref * T; 
rgb_calc = lin2rgb(linrgb_calc);
end
