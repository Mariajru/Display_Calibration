function [n, R_points, G_points, B_points, Y_points] = ...
    Normal_plane(R_hsv, G_hsv, B_hsv, Y_hsv)
% Computes the normals of the R, G and B planes by performing the 
% plane fitting using the 3D points of each plane
%
% INPUTS:   n -> 3 by 3 matrix. Each row is the normal of one plane
%           R_points, G_points, B_points -> linearized R, G and B data 
%           points
% OUTPUTS:  R_hsv, G_hsv, B_hsv -> data values in HSV color space
%
% Author:   Maria-Jose Rueda - mariajoserdmnts@gmail.com

%% UNIQUE RED
% Change in the range 0 to 1 and convert hsv to rgb
R_hsv(:,2) = R_hsv(:,2)/100;
R_hsv(:,3) = R_hsv(:,3)/100;
R_hsv(:,1) = R_hsv(:,1)/360;
R_hue = hsv2rgb(R_hsv);
R_hue = round(R_hue * 255);
% Change red RGB points into linear RGB
lin_R1 = rgb2lin(R_hue(1,:));
lin_R2 = rgb2lin(R_hue(2,:));
lin_R3 = rgb2lin(R_hue(3,:));
lin_R4 = rgb2lin(R_hue(4,:));
lin_R5 = rgb2lin(R_hue(5,:));
lin_R6 = rgb2lin(R_hue(6,:));
R_points = [lin_R1; lin_R2; lin_R3; lin_R4; lin_R5; lin_R6];
% Solve the equation of a plane and obtain the normal vector
[n_R,V_R,p_R] = affine_fit(R_points);

%% UNIQUE GREEN
% Change in the range 0 to 1 and convert hsv to rgb
G_hsv(:,2) = G_hsv(:,2)/100;
G_hsv(:,3) = G_hsv(:,3)/100;
G_hsv(:,1) = G_hsv(:,1)/360;
G_hue = hsv2rgb(G_hsv);
G_hue = round(G_hue * 255);
% Change into linear RGB
lin_G1 = rgb2lin(G_hue(1,:));
lin_G2 = rgb2lin(G_hue(2,:));
lin_G3 = rgb2lin(G_hue(3,:));
lin_G4 = rgb2lin(G_hue(4,:));
lin_G5 = rgb2lin(G_hue(5,:));
lin_G6 = rgb2lin(G_hue(6,:));
G_points = [lin_G1; lin_G2; lin_G3; lin_G4; lin_G5; lin_G6];
% Solve the equation of a plane and obtain the normal vector
[n_G,V_G,p_G] = affine_fit(G_points);

%% UNIQUE BLUE
% Change in the range 0 to 1 and convert hsv to rgb
B_hsv(:,2) = B_hsv(:,2)/100;
B_hsv(:,3) = B_hsv(:,3)/100;
B_hsv(:,1) = B_hsv(:,1)/360;
B_hue = hsv2rgb(B_hsv);
B_hue = round(B_hue * 255);
% Change into linear RGB
lin_B1 = rgb2lin(B_hue(1,:));
lin_B2 = rgb2lin(B_hue(2,:));
lin_B3 = rgb2lin(B_hue(3,:));
lin_B4 = rgb2lin(B_hue(4,:));
lin_B5 = rgb2lin(B_hue(5,:));
lin_B6 = rgb2lin(B_hue(6,:));
B_points = [lin_B1; lin_B2; lin_B3; lin_B4; lin_B5; lin_B6];
% Solve the equation of a plane and obtain the normal vector
[n_B,V_B,p_B] = affine_fit(B_points);

%% UNIQUE YELLOW
% Change in the range 0 to 1 and convert hsv to rgb
Y_hsv(:,2) = Y_hsv(:,2)/100;
Y_hsv(:,3) = Y_hsv(:,3)/100;
Y_hsv(:,1) = Y_hsv(:,1)/360;
Y_hue = hsv2rgb(Y_hsv);
Y_hue = round(Y_hue * 255);
% Change into linear RGB
lin_Y1 = rgb2lin(Y_hue(1,:));
lin_Y2 = rgb2lin(Y_hue(2,:));
lin_Y3 = rgb2lin(Y_hue(3,:));
lin_Y4 = rgb2lin(Y_hue(4,:));
lin_Y5 = rgb2lin(Y_hue(5,:));
lin_Y6 = rgb2lin(Y_hue(6,:));
Y_points = [lin_Y1; lin_Y2; lin_Y3; lin_Y4; lin_Y5; lin_Y6];
% Solve the equation of a plane and obtain the normal vector
[n_Y,V_Y,p_Y] = affine_fit(Y_points);

%% NORMAL MATRIX reference display
% Return a matrix with the normal vectors
n = [n_R, n_G, n_B, n_Y]';

end