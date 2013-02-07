% ========================================================================
% Extracting four components from an input optical flow field
% USAGE: [imofxpb,imofxmb,imofypb,imofymb]=computeofcomponents(x1,y1,label)
% Inputs
%       x1              -x component of an optical flow field
%       y1              -y component of an optical flow field
%       label           -normalization tag for each component
% Outputs
%       imofxpb           -extracted blurred, normalizaed x+ component
%       imofxmb           -extracted blurred, normalizaed x- component
%       imofypb           -extracted blurred, normalizaed y+ component
%       imofymb           -extracted blurred, normalizaed y- component
%
% Author: Zhuolin Jiang (zhuolin@umiacs.umd.edu)
% Date: 07-21-2012
% ========================================================================

function [imofxpb,imofxmb,imofypb,imofymb]=computeofcomponents(x1,y1,label)
% compute the optical flow four components
imofx = x1;
imofy = y1;

% get the four components
imofxp = (imofx>0).*imofx;
imofxm = -(imofx<0).*imofx;
imofyp = (imofy>0).*imofy;
imofym = -(imofy<0).*imofy;

% blurring motion channels
w = fspecial('gaussian',[50,50],5);
imofxpb = imfilter(imofxp,w);
imofxmb = imfilter(imofxm,w);
imofypb = imfilter(imofyp,w);
imofymb = imfilter(imofym,w);
if(label==1)
    % normalize the component of optical flow
    imofxpb = imofxpb./(norm(imofxpb)+eps);
    imofxmb = imofxmb./(norm(imofxmb)+eps);
    imofypb = imofypb./(norm(imofypb)+eps);
    imofymb = imofymb./(norm(imofymb)+eps);
end

% clear the variables 
clear imofyp imofym imofxp imofxm imofx imofy