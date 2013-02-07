% ========================================================================
% Compute gradient observations for an input image
% USAGE: [mag,theta] = computegradientdata(img)
%
% Inputs
%       img              -input image
% Outputs
%       mag              -magnitude image of gradients
%       theta            -direction image of gradients
%
% Author: Zhuolin Jiang (zhuolin@umiacs.umd.edu)
% Date: 07-21-2012
% ========================================================================

function [mag,theta] = computegradientdata(img)
imgr = double(img(:,:,1));  % r component
imgg = double(img(:,:,2));  % g component
imgb = double(img(:,:,3));  % b component

maskw = fspecial('gaussian',[50,50],2);
imgr = imfilter(imgr,maskw);
imgg = imfilter(imgg,maskw);
imgb = imfilter(imgb,maskw);

[img_h,img_w] = size(imgr);

gximgr = zeros(img_h,img_w);
gximgg = zeros(img_h,img_w);
gximgb = zeros(img_h,img_w);

gyimgr = zeros(img_h,img_w);
gyimgg = zeros(img_h,img_w);
gyimgb = zeros(img_h,img_w);

mag = zeros(img_h,img_w,'single');
theta = zeros(img_h,img_w,'single');

for i=2:img_h-1
    for j=2:img_w-1
        maxv=0;
        mdx=0;
        mdy=0;
        v1 = imgr(i,j+1) - imgr(i,j-1); % x direction
        v2 = imgr(i+1,j) - imgr(i-1,j); % y direction
        v=sqrt(v1*v1+v2*v2);
        if(v>=maxv)
            maxv=v;
            mdx=v1;
            mdy=v2;
        end
        v1 = imgg(i,j+1) - imgg(i,j-1); % x direction
        v2 = imgg(i+1,j) - imgg(i-1,j); % y direction
        v=sqrt(v1*v1+v2*v2);
        if(v>=maxv)
            maxv=v;
            mdx=v1;
            mdy=v2;
        end
        v1 = imgb(i,j+1) - imgb(i,j-1); % x direction
        v2 = imgb(i+1,j) - imgb(i-1,j); % y direction
        v=sqrt(v1*v1+v2*v2);
        if(v>=maxv)
            maxv=v;
            mdx=v1;
            mdy=v2;
        end
        
        if(mdx==0&&mdy==0)
            w=pi/2.0;
        elseif(mdx==0&&mdy~=0)
            w=pi/2.0;
        elseif(mdx~=0&&mdy==0)
            w=0;
        elseif(mdx*mdy>0)
            w=atan(mdy/mdx);
        else
            w=pi-atan(-mdy/mdx);
        end
        
        mag(i,j) = maxv;
        theta(i,j) = w;
    end
end