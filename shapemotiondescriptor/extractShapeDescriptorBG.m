% ========================================================================
% Extracting shape descriptors from the silhouette observations
% USAGE: shapedes = extractShapeDescriptorBG(bimg, actionIR, nquant)
% Inputs
%       bimg            -sihouette image
%       actionIR        -action interest region
%       nquant          -size of a uniform grid overlaid on the interest 
%                        region (e.g. 16 means that the ROI will be divided 
%                        into 16x16 grids) 
% Outputs
%       shapedes        -extracted shape descriptor
%
% Author: Zhuolin Jiang (zhuolin@umiacs.umd.edu)
% Date: 07-21-2012
% ========================================================================

function shapedes = extractShapeDescriptorBG(bimg, actionIR, nquant)

cwid=4;
[height, width]=size(bimg);
min_x = actionIR.xmin;
max_x = actionIR.xmax;
size_x = max_x-min_x+1; % size x
min_y = actionIR.ymin;
max_y = actionIR.ymax;
size_y = max_y-min_y+1; % size y
mn_x = max(min_x, 1); mx_x = min(max_x, width);
mn_y = max(min_y, 1); mx_y = min(max_y, height);

subimg = zeros(size_y,size_x);
subimg(1+mn_y-min_y:1+mx_y-min_y,1+mn_x-min_x:1+mx_x-min_x) = bimg(mn_y:mx_y,mn_x:mx_x);
norm_subimg=imresize(subimg, [nquant*cwid nquant*cwid],'bilinear');

for m=1:nquant
    for n=1:nquant
        shapedes(1,(m-1)*nquant+n)=sum(sum(norm_subimg(1+(m-1)*cwid:m*cwid,1+(n-1)*cwid:n*cwid)));
    end
end
shapedes = shapedes/(norm(shapedes)+eps);