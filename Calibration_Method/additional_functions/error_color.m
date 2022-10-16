function err =  error_color(C1,C2,metric)
% Colorimetric error measures.
%
% REFERENCES:
% -> CIE76:
%       "The CIE 1976 color-difference formulae"; Robertson A.; Color 
%       research and application; Vol 2. Issue 1; pp. 0361-2317
% -> CIE94:
%       "Industrial colour-difference evaluation - 
%       CIE 116-1995"; CIE - techical report;
% -> CIE2000:
%       "The CIEDE2000 Color-Difference Formula: Implementation Notes, 
%       Supplementary Test Data, and Mathematical Observations,", G. Sharma, 
%       W. Wu, E. N. Dalal, submitted to Color Research and Application, 
%       January 2004.
%
%INPUT:     C1      [3 x n]  -> color 1 in CIE-L*a*b* space
%           C2      [3 x n]  -> color 2 in CIE-L*a*b* space
%           metric  [string] -> 'CIE76'       : color difference CIE76
%                               'CIE94'       : color difference CIE94
%                               'CIE2000'     : color difference CIEDE2000
%OUTPUT:    err     [1 x n]  -> error in a certain metric
%
% Author:   Timo Eckhard - timo.eckhard@gmx.com
%           Jia Song     - songjia815@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch metric
    case{'CIE76'}
        %CIE-L*a*b* color difference CIE76
        err = sqrt(sum((C1-C2).^2));

    case {'CIE94'}
        %CIE-94 color difference CIE94
        
        %parametric factors: all 1 under reference viewing conditions (They
        %are illuminated at 1000 lux, and viewed against a background of 
        %uniform grey, with L* of 50, under illumination simulating D65.)
        kl = 1;
        kc = 1;
        kh = 1;
        
        c1 = (C1(2,:).^2+C1(3,:).^2).^(1/2);                                   %(a1^2+b1^2)^(1/2)
        c2 = (C2(2,:).^2+C2(3,:).^2).^(1/2);                                   %(a2^2+b2^2)^(1/2)
        dl = C1(1,:)-C2(1,:);                                               %L1 -L2
        
        dc = c2-c1;
        
        de = sqrt(sum((C1-C2).^2));    %CIE-76 color difference
        
        dh = zeros(1,size(de,2));
        idx = (de.^2) > (dl.^2+dc.^2);
        dh(idx) = ((de(idx)).^2 - (dl(idx)).^2 - (dc(idx)).^2).^(1/2);
        
        %weighting functions
        sl = 1;
        sc = 1 + 0.045*c1;
        sh = 1 + 0.015*c1;
        
        %CIE-94 color difference
        err = ((dl./(kl*sl)).^2 + (dc./(kc*sc)).^2 + (dh./(kh*sh)).^2 ).^(1/2);
        
    case{'CIE2000'}
        % from: http://www.ece.rochester.edu/~gsharma/ciede2000/dataNprograms/deltaE2000.m
        % CIE-L*a*b* color difference CIEDE2000
        
        % Compute the CIEDE2000 color-difference between the sample between a reference
        % with CIELab coordinates C2 and a standard with CIELab coordinates 
        % C1
        % The function works on multiple standard and sample vectors too
        % provided C1 and C2 are K x 3 matrices with samples and 
        % standard specification in corresponding rows of C1 and C2
        % The optional argument KLCH is a 1x3 vector containing the
        % the value of the parametric weighting factors kL, K1, and K2
        % these default to 1 if KLCH is not specified.

        % Based on the article:
        % "The CIEDE2000 Color-Difference Formula: Implementation Notes, 
        % Supplementary Test Data, and Mathematical Observations,", G. Sharma, 
        % W. Wu, E. N. Dalal, submitted to Color Research and Application, 
        % January 2004.
        % available at http://www.ece.rochester.edu/~/gsharma/ciede2000/
        
        C1 = C1';
        C2 = C2';
        
        %function de00 = deltaE2000(C1,C2, KLCH )
 
        % Parametric factors 
        kl = 1; K1=1; K2 =1;    %default values
        
        Lstd = C1(:,1)';
        astd = C1(:,2)';
        bstd = C1(:,3)';
        Cabstd = sqrt(astd.^2+bstd.^2);

        Lsample = C2(:,1)';
        asample = C2(:,2)';
        bsample = C2(:,3)';
        Cabsample = sqrt(asample.^2+bsample.^2);

        Cabarithmean = (Cabstd + Cabsample)/2;

        G = 0.5* ( 1 - sqrt( (Cabarithmean.^7)./(Cabarithmean.^7 + 25^7)));
       
        apstd = (1+G).*astd;                    % aprime in paper
        apsample = (1+G).*asample;              % aprime in paper
        Cpsample = sqrt(apsample.^2+bsample.^2);
        Cpstd = sqrt(apstd.^2+bstd.^2);
        
        % Compute product of chromas and locations at which it is zero for use later
        Cpprod = (Cpsample.*Cpstd);
        zcidx = find(Cpprod == 0);

        % Ensure hue is between 0 and 2pi
        % NOTE: MATLAB already defines atan2(0,0) as zero but explicitly set it
        % just in case future definitions change
        hpstd = atan2(bstd,apstd);
        hpstd = hpstd+2*pi*(hpstd < 0);  % rollover ones that come -ve
        hpstd((abs(apstd)+abs(bstd))==0) = 0;
        hpsample = atan2(bsample,apsample);
        hpsample = hpsample+2*pi*(hpsample < 0);
        hpsample((abs(apsample)+abs(bsample))==0) = 0;

        dL = (Lsample-Lstd);
        dC = (Cpsample-Cpstd);
        % Computation of hue difference
        dhp = (hpsample-hpstd);
        dhp = dhp - 2*pi* (dhp > pi );
        dhp = dhp + 2*pi* (dhp < (-pi) );
        % set chroma difference to zero if the product of chromas is zero
        dhp(zcidx ) = 0;

        % Note that the defining equations actually need
        % signed Hue and chroma differences which is different
        % from prior color difference formulae

        dH = 2*sqrt(Cpprod).*sin(dhp/2);
        %dH2 = 4*Cpprod.*(sin(dhp/2)).^2;

        % weighting functions
        Lp = (Lsample+Lstd)/2;
        Cp = (Cpstd+Cpsample)/2;
        % Average Hue Computation
        % This is equivalent to that in the paper but simpler programmatically.
        % Note average hue is computed in radians and converted to degrees only 
        % where needed
        hp = (hpstd+hpsample)/2;
        % Identify positions for which abs hue diff exceeds 180 degrees 
        hp = hp - ( abs(hpstd-hpsample)  > pi ) *pi;
        % rollover ones that come -ve
        hp = hp+ (hp < 0) *2*pi;
        % Check if one of the chroma values is zero, in which case set 
        % mean hue to the sum which is equivalent to other value
        hp(zcidx) = hpsample(zcidx)+hpstd(zcidx);

        Lpm502 = (Lp-50).^2;
        Sl = 1 + 0.015*Lpm502./sqrt(20+Lpm502);  
        Sc = 1+0.045*Cp;
        T = 1 - 0.17*cos(hp - pi/6 ) + 0.24*cos(2*hp) + 0.32*cos(3*hp+pi/30) ...
            -0.20*cos(4*hp-63*pi/180);
        Sh = 1 + 0.015*Cp.*T;
        delthetarad = (30*pi/180)*exp(- ( (180/pi*hp-275)/25).^2);
        Rc =  2*sqrt((Cp.^7)./(Cp.^7 + 25^7));
        RT =  - sin(2*delthetarad).*Rc;

        klSl = kl*Sl;
        kcSc = K1*Sc;
        khSh = K2*Sh;

        % The CIE 00 color difference
        err = sqrt( (dL./klSl).^2 + (dC./kcSc).^2 + (dH./khSh).^2 + RT.*(dC./kcSc).*(dH./khSh) );
               
        otherwise
        error(['-> error_color.m: ',metric,' is not known by the function.']);
end
    
if any(isnan(err))
    warning('->error_color.m: the computed error is not a number');
end

end

