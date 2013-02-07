% ========================================================================
% Extracting shape descriptors from image gradient observations
% USAGE: [hogdes, hoghistMat] = extractShapeDescriptorHOG(magimage, 
%                thetaimage, gridquant, thequant, actionIR, isOutputHogMat)
%
% Inputs
%       magimage            -gradient magnitude image
%       thetaimage          -gradient direction image
%       gridquant           -size of a uniform grid overlaid on the
%                            interest region
%       thequant            -number of bins for gradient directions 
%       actionIR            -action interest region
%       isOutputHogMat      -tag for 3D histogram output 
% Outputs
%       hogdes              -extracted HOG-based shape descriptors
%       hoghistMat          -3D histogram for HOG descriptors 
%                            (Visualization purpose)
%
% Author: Zhuolin Jiang (zhuolin@umiacs.umd.edu)
% Date: 07-21-2012
% ========================================================================

function [hogdes, hoghistMat] = extractShapeDescriptorHOG(magimage, thetaimage, gridquant, thequant, actionIR, isOutputHogMat)

xmin = actionIR.xmin;
xmax = actionIR.xmax;
ymin = actionIR.ymin;
ymax = actionIR.ymax;

mag = magimage(ymin:ymax,xmin:xmax);
theta = thetaimage(ymin:ymax,xmin:xmax);
imgwidth = size(mag,2);
imgheight = size(mag,1);

hogdes = zeros(1,gridquant*gridquant*thequant);
if(isOutputHogMat)
    hoghistMat = zeros(gridquant,gridquant,thequant);
end
for i=1:gridquant+1
    gridx(i) = round(1 + (imgwidth - 1)*(i-1)/gridquant);
    gridy(i) = round(1 + (imgheight - 1)*(i-1)/gridquant);
end

for i=1:gridquant
    for j=1:gridquant
        reggradec = double(theta(gridy(i):gridy(i+1),gridx(j):gridx(j+1)));
        reggramag = double(mag(gridy(i):gridy(i+1),gridx(j):gridx(j+1)));
        hoghist = zeros(1,thequant);
        for ii=1:size(reggradec,1)
            for jj=1:size(reggradec,2)
                intervalnum = ceil(reggradec(ii,jj)/(pi/thequant)); % get the interval number
                intervalnum = max(intervalnum,1);
                intervalnum = min(intervalnum,thequant);
                hoghist(intervalnum) = hoghist(intervalnum) + reggramag(ii,jj);  
            end
        end
        hoghist = hoghist./(norm(hoghist)+eps);
        if(isOutputHogMat)
            hoghistMat(i,j,:) = reshape(hoghist,[1 1 thequant]);
        end
        hogdes(1,((i-1)*gridquant+(j-1))*thequant+1:((i-1)*gridquant+(j-1))*thequant+thequant)=hoghist;
    end
end