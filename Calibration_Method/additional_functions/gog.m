function [gogvals] = gog(rawdata)
% GOG model to linearize RGB device-dependent values. 
%
% REFERENCES:   Westland, S., Ripamonti, C., & Cheung, V. (2012). 
%               Computational colour science using MATLAB. 
%               John Wiley & Sons.

% Compute the XYZ values with the Yxy data
samples = 12;
XYZ = zeros(samples,3);
for i=1:samples
    X = rawdata(i,4);
    Y = rawdata(i,5);
    Z = rawdata(i,6);
    XYZ(i,:) = [X Y Z];
end

% Matrix with the measured XYZ of the Red Grenn and Blue channels. With 
% this transformation we can obtain the XYZ values from **linear and 
% normalized RGB**. 
% [X,Y,Z]' = [X_red, X_green, X_blue; Y_red, Y_green, Y_blue; ...
% Z_red, Z_green, Z_blue] * [R,G,B]';
M = [XYZ(1,1) XYZ(2,1) XYZ(3,1); XYZ(1,2) XYZ(2,2)...
      XYZ(3,2); XYZ(1,3) XYZ(2,3) XYZ(3,3)];

% get the neutral samples
neut_XYZ = XYZ(4:12,:);
% get their linear RGB values
neut_RGB = ((M)^(-1)*neut_XYZ')';
% and the corresponding non-linear RGBs
nonl_RGB = rawdata(4:12,1:3)/255;

% compute the GOG values for each channel
x1=linspace(0,1,101);
% red channel
x = [1, 1]; % start the minimization in 1,1
options = optimset;
x = fminsearch(@gogtest,x,options,nonl_RGB(:,1), neut_RGB(:,1));
gogvals(1,:) = x;
% Plot the result:
figure
plot(nonl_RGB(:,1),neut_RGB(:,1),'r*')
% From the predicted gog compute the linearized RGB
y1 = compgog(gogvals(1,:),x1);  % **each channel has a different gog values
% Plot the result:
hold on
plot(x1,y1,'r-')
% green channel
x = [1, 1];
options = optimset;
x = fminsearch(@gogtest,x,options,nonl_RGB(:,2), neut_RGB(:,2));
gogvals(2,:) = x;
hold on
plot(nonl_RGB(:,2),neut_RGB(:,2),'g*')
y2 = compgog(gogvals(2,:),x1);
hold on
plot(x1,y2,'g-')
% blue channel
x = [1, 1];
options = optimset;
x = fminsearch(@gogtest,x,options,nonl_RGB(:,3), neut_RGB(:,3));
gogvals(3,:) = x;
hold on
plot(nonl_RGB(:,3),neut_RGB(:,3),'b*')
y3 = compgog(gogvals(3,:),x1);
hold on
plot(x1,y3,'b-')
disp(gogvals)

% now take the non-linear RGB values of the test samples
% and linearize them using the gogvals we calculate, for each channel
% PUT THIS OUTSIDE
%red = rgb_data(:,1)/255;
%RGB(:,1) = compgog(gogvals(1,:), red);
%green = rgb_data(:,2)/255;
%RGB(:,2) = compgog(gogvals(2,:), green);
%blue = rgb_data(:,3)/255;
%RGB(:,3) = compgog(gogvals(3,:), blue);

end
%% function [err] = gogtest(gogs,dacs,rgbs)
% Computes the error between measured and predicted
% linearized dac values for a given set of GOG values
% gogs is a 2 by 1 matrix containing gamma and gain
% dacs is an n by 1 matrix containing dac values
% rgbs is an n by 1 matrix that is obtained from a
% linear transform of measured XYZ values
function [err] = gogtest(gogs,dacs,rgbs)
gamma = gogs(1);
gain = gogs(2);
% Force to be row matrices
dacs = dacs(:)';
rgbs = rgbs(:)';
if (length(dacs) ~= length(rgbs))
disp('dacs and rgbs vectors must be the same length'); err = 0;
return
end
% Compute gog model predictions
for i=1:length(dacs)
    if (gain*dacs(i) + (1-gain)) <= 0
        pred(i)=0;
    else
        pred(i)=(gain*dacs(i) + (1-gain)) ^ gamma; 
    end
end
% Force to be a row matrix
pred = pred(:)';
% Compute RMS error
err = sqrt((sum((rgbs-pred).*(rgbs-pred)))/length(dacs));

end



