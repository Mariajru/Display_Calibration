% Data processing before computing the matrix-based transformation to 
% perform the calibration method. 
%
% Author:   Maria-Jose Rueda - mariajoserdmnts@gmail.com

%% ----------------------------DATA----------------------------------------
% Data collected in HSV color space. Copy the collected data in this file

% Profile 1 - pos 16 ws
R_hsv_Profile1 = [335,100,100; 347,56,100; 347,30,100; 337,100,50; ...
    344,59,49; 343,31,47];        
G_hsv_Profile1 = [95,100,100; 115,55,100; 123,27,100; 115,100,47; ...
    104,59,47; 106,32,47];
B_hsv_Profile1 = [215,100,100; 226,64,100; 216,33,100; 220,100,51; ...
    226,67,49; 218,35,48];
O_hsv_Profile1 = [29,100,100; 15,62,100; 11,34,100; 22,100,49; ...
    15,66,48; 17,37,47]; 
Y_hsv_Profile1 = [60,100,100; 61,60,100; 62,35,100; 60,100,47; ...
    53,65,47; 53,37,47];
Grey_hsv_Profile1 = [0, 4, 50];
W_hsv_Profile1 = [0, 0, 50]; 
% Profile 2 - neg 16 wr
R_hsv_Profile2 = [25,100,100; 15,62,100; 19,35,100; 22,100,49; ...
    15,66,48; 17,37,47];         
G_hsv_Profile2 = [145,100,100; 140,55,100; 145,31,100; 138,100,47; ...
    115,59,47; 123,29,47];
B_hsv_Profile2 = [251,100,100; 229,62,100; 220,34,100; 261,100,51; ...
    237,56,49; 223,35,48];
O_hsv_Profile2 = [38,100,100; 32,63,100; 30,36,100; 41,100,48; ...
    30,66,48; 37,38,47]; 
Y_hsv_Profile2 = [73,100,100; 78,58,100; 97,31,100; 64,100,47; ...
    65,63,47; 67,36,47];
W_hsv_Profile2 = [120, 8, 50]; 
Grey_hsv_Profile2 = [120, 8, 50];
% Profile 3 sRGB - User
R_hsv_Profile3 = [359,100,100; 4,59,100; 6,33,100; 360,100,50; ...
    1,59,49; 6,34,47];
G_hsv_Profile3 = [112,100,100; 115,55,100; 114,29,100; 115,100,47; ...
    115,59,47; 114,31,47];
B_hsv_Profile3 = [247,100,100; 233,57,100; 222,33,100; 241,100,52; ...
    228,65,49; 225,34,48];
O_hsv_Profile3 = [30,100,100; 26,63,100; 25,36,100; 34,100,48; ...
    27,66,48; 25,38,47];
Y_hsv_Profile3 = [63,100,100; 58,60,100; 62,35,100; 60,100,47; ...
    61,64,47; 59,36,47];
Grey_hsv_Profile3 = [0, 4, 50];
W_hsv_Profile3 = [0, 0, 50];

%% ----------------------------DATA PROCESSING-----------------------------
% The previous data is processed to compute the calibration method
% Reference display 
R_hsv = R_hsv_Profile2;          
G_hsv = G_hsv_Profile2;
B_hsv = B_hsv_Profile2;
O_hsv = O_hsv_Profile2;
Y_hsv = Y_hsv_Profile2;
W_hsv = W_hsv_Profile2;
Grey_hsv = Grey_hsv_Profile2;
W_rgb_ref(1,1) = W_hsv_Profile2(1,1)/360;
W_rgb_ref(1,2) = W_hsv_Profile2(1,2)/100;
W_rgb_ref(1,3) = W_hsv_Profile2(1,3)/100;
W_rgb_ref = round((hsv2rgb(W_rgb_ref))*255);
% Change into linear-RGB values
W_lin_ref = rgb2lin(W_rgb_ref);
% Calculate the normals of each plane
[n_Ref, R_points_ref, G_points_ref, B_points_ref, Y_points_ref] = ... 
    Normal_plane(R_hsv, G_hsv, B_hsv, Y_hsv);
% User display
R_hsv2 = R_hsv_Profile3;
G_hsv2 = G_hsv_Profile3;
B_hsv2 = B_hsv_Profile3;
O_hsv2 = O_hsv_Profile3;
Y_hsv2 = Y_hsv_Profile3;
W_hsv2 = W_hsv_Profile3;
Grey_hsv2 = Grey_hsv_Profile3;
W_rgb_user(1,1) = W_hsv_Profile3(1,1)/360;
W_rgb_user(1,2) = W_hsv_Profile3(1,2)/100;
W_rgb_user(1,3) = W_hsv_Profile3(1,3)/100;
W_rgb_user = round((hsv2rgb(W_rgb_user))*255);
% Change into linear-RGB values
W_lin_user = rgb2lin(W_rgb_user);
% Calculate the normals of each plane
[n_User, R_points_user, G_points_user, B_points_user, Y_points_user] = ... 
    Normal_plane(R_hsv2, G_hsv2, B_hsv2, Y_hsv2);
% rgb values
% Reference display
R_rgb = hsvtorgb(R_hsv);
G_rgb = hsvtorgb(G_hsv);
B_rgb = hsvtorgb(B_hsv);
O_rgb = hsvtorgb(O_hsv);
Y_rgb = hsvtorgb(Y_hsv);
Grey_rgb = hsvtorgb(Grey_hsv); 
color_ref = [R_rgb; G_rgb; B_rgb; O_rgb; Y_rgb; Grey_rgb];
% User display
R_rgb2 = hsvtorgb(R_hsv2);
G_rgb2 = hsvtorgb(G_hsv2);
B_rgb2 = hsvtorgb(B_hsv2);
O_rgb2 = hsvtorgb(O_hsv2);
Y_rgb2 = hsvtorgb(Y_hsv2);
Grey_rgb2 = hsvtorgb(Grey_hsv2);
color_user = [R_rgb2; G_rgb2; B_rgb2; O_rgb2; Y_rgb2; Grey_rgb2];
% Read the image 
I = imread('ColorChecker_sRGB_D50.tif');
% linear rgb values from Reference and User displays
P_ref = [R_points_ref; G_points_ref; B_points_ref];
P_user = [R_points_user; G_points_user; B_points_user];
% Choose the index of the patch you want to show
n_patch = 1;
P = P_ref(n_patch,:,:);
P_u = P_user(n_patch,:,:);
if n_patch>=1 && n_patch<=6
    n = n_User(1,:);
    n_R = n_Ref(1,:);
elseif n_patch>=7 && n_patch <=12
    n = n_User(2,:);
    n_R = n_Ref(2,:);
elseif n_patch>=13 && n_patch<=18
    n = n_User(3,:);
    n_R = n_Ref(3,:);
end
% Plot the reference and the user
% Original Image 
figure('Name', 'Original Image (Reference display)'); 
imshow(I, 'InitialMagnification', 'fit');
rgb_ref = lin2rgb(P);
rgb_user = lin2rgb(P_u);
[Img_ref] = patch_imshow(rgb_ref, ...
    'Color selected in the Reference display');
[Img_user] = patch_imshow(rgb_user, ...
    'Color selected in the User display');
[Grey_ref] = patch_imshow(W_rgb_ref, ...
    'Grey selected in the Reference display');
[Grey_user] = patch_imshow(W_rgb_user, ...
    'Grey selected in the User display');

% Patches measurements (To validate the transformations)
% HSV values
color_patches = [0 100 100; 0 80 100; 0 60 100; 0 40 100; 0 20 100; ...
    0 100 50; 0 80 50; 0 60 50; 0 40 50; 0 20 50; ...
    120 100 100; 120 80 100; 120 60 100; 120 40 100; 120 20 100; ...
    120 100 50; 120 80 50; 120 60 50; 120 40 50; 120 20 50; ...
    240 100 100; 240  80 100; 240  60 100; 240  40 100; 240  20 100; ...
    240 100 50; 240  80 50; 240  60 50; 240  40 50; 240  20 50; ...
    60 100 100; 60 80 100; 60 60 100; 60 40 100; 60 20 100; ...
    60 100 50; 60 80 50; 60 60 50; 60 40 50; 60 20 50; ...
    30 100 100; 30 80 100; 30 60 100; 30 40 100; 30 20 100; ...
    30 100 50; 30 80 50; 30 60 50; 30 40 50; 30 20 50; ...
    180 100 100; 180 80 100; 180 60 100; 180 40 100; 180 20 100; ...
    180 100 50; 180 80 50; 180 60 50; 180 40 50; 180 20 50; ...
    300 100 100; 300 80 100; 300 60 100; 300 40 100; 300 20 100; ...
    300 100 50; 300 80 50; 300 60 50; 300 40 50; 300 20 50; ...
    270 100 100; 270 80 100; 270 60 100; 270 40 100; 270 20 100; ...
    270 100 50; 270 80 50; 270 60 50; 270 40 50; 270 20 50; ...
    150 100 100; 150 80 100; 150 60 100; 150 40 100; 150 20 100; ...
    150 100 50; 150 80 50; 150 60 50; 150 40 50; 150 20 50; ...
    ];
color_patches(:,1) = color_patches(:,1)/360;
color_patches(:,2) = color_patches(:,2)/100;
color_patches(:,3) = color_patches(:,3)/100;
color_patches = (hsv2rgb(color_patches))*255;
% RGB values
color_checker = [115 82 68; 194 150 130; 98 112 157; 87 108 67; ...
    133 128 177; 103 189 170; 214 126 44; 80 91 166; 193 90 99; ... 
    94 60 108; 157 188 64; 224 163 46; 56 61 150; 70 148 73; ...
    175 54 60; 231 199 31; 187 86 149; 8 133 161; 243 243 242; ...
    200 200 200; 160 160 160; 122 122 121; 85 85 85; 52 52 52];
% Combine all arrays
color_array = [color_patches; color_checker; 0 0 0];
