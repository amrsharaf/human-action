% ========================================================================
% Extracting motion descriptors from the optical flow observations
% USAGE: [xpdes,xmdes,ypdes,ymdes] = extractMotionDescriptor(ofmatx,ofmaty,
%                                   actionIR,gridn)
% Inputs
%       ofmatx          -x component of an optical flow field
%       ofmaty          -y component of an optical flow field
%       actionIR        -action interest region
%       gridn           -size of a uniform grid overlaid on the interest 
%                        region (e.g. 16 means that the ROI will be divided 
%                        into 16x16 grids) 
% Outputs
%       xpdes           -extracted descriptor from the x+ component
%       xmdes           -extracted descriptor from the x- component
%       ypdes           -extracted descriptor from the y+ component
%       ymdes           -extracted descriptor from the y- component
%
% Author: Zhuolin Jiang (zhuolin@umiacs.umd.edu)
% Date: 07-21-2012
% ========================================================================

function [xpdes,xmdes,ypdes,ymdes] = extractMotionDescriptor(ofmatx,ofmaty,actionIR,gridn)

sregnum = gridn*gridn;
nnperline = sqrt(sregnum)+1;  % the number of nodes per line
mn_x = actionIR.xmin;
mx_x = actionIR.xmax;
mn_y = actionIR.ymin;
mx_y = actionIR.ymax;
regpara.y1 = mn_y;
regpara.y2 = mx_y;
regpara.x1 = mn_x;
regpara.x2 = mx_x;

for i=1:nnperline
    gridx(i) = regpara.x1 + (regpara.x2 - regpara.x1)*(i-1)/sqrt(sregnum);
    gridy(i) = regpara.y1 + (regpara.y2 - regpara.y1)*(i-1)/sqrt(sregnum);
end

[height, width]=size(ofmatx);
minx = max(regpara.x1,1);
miny = max(regpara.y1,1);
maxx = min(regpara.x2,width);
maxy = min(regpara.y2,height);
    
ofmatsx = zeros(regpara.y2-regpara.y1+1,regpara.x2-regpara.x1+1);
ofmatsy = zeros(regpara.y2-regpara.y1+1,regpara.x2-regpara.x1+1);

ofmatsx((miny-regpara.y1+1):(maxy-regpara.y1+1), (minx-regpara.x1+1):(maxx-regpara.x1+1)) = ofmatx(miny:maxy,minx:maxx);
ofmatsy((miny-regpara.y1+1):(maxy-regpara.y1+1), (minx-regpara.x1+1):(maxx-regpara.x1+1)) = ofmaty(miny:maxy,minx:maxx);

% compute the four components
[imofxpb,imofxmb,imofypb,imofymb] = computeofcomponents(ofmatsx,ofmatsy,1);

% compute the average
for i=1:nnperline-1
    for j=1:nnperline-1
        ymin = round(gridy(i) - regpara.y1 + 1);
        ymax = round(gridy(i+1) - regpara.y1 + 1);
        xmin = round(gridx(j)- regpara.x1 + 1);
        xmax = round(gridx(j+1) - regpara.x1 + 1);
        xpdes(i,j) = mean(mean(imofxpb(ymin:ymax,xmin:xmax)));
        xmdes(i,j) = mean(mean(imofxmb(ymin:ymax,xmin:xmax)));
        ypdes(i,j) = mean(mean(imofypb(ymin:ymax,xmin:xmax)));
        ymdes(i,j) = mean(mean(imofymb(ymin:ymax,xmin:xmax)));
    end
end

clear ofmatsx ofmatsy gridx gridy







