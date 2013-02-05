% This m-file implements the approximate median algorithm for background
% subtraction.  It may be used free of charge for any purpose (commercial
% or otherwise), as long as the author (Seth Benton) is acknowledged.

clear all

source = aviread('../weizmann_part/videos/jump2');
% Threshold value for background subtraction
thresh = 35;           
% read in first frame as initial background frame
bg = source(1).cdata;
% convert background to grayscale, cast to double to avoid negative overflow
bg_bw = double(rgb2gray(bg));
% set frame size variables
fr_size = size(bg);
height = fr_size(1);
width = fr_size(2);
fg = zeros(height, width);
% process frames
for i = 2:length(source)
    fr = source(i).cdata;
    fr_bw = rgb2gray(fr); % convert frame to grayscale
    fr_diff = abs(double(fr_bw) - double(bg_bw));% cast operands as double to avoid negative overflow
    % if fr_diff > thresh pixel in foreground  
    for j=1:width 
         for k=1:height
             if ((fr_diff(k,j) > thresh))
                 fg(k,j) = fr_bw(k,j);
             else
                 fg(k,j) = 0;
             end
             if (fr_bw(k,j) > bg_bw(k,j)) 
                 bg_bw(k,j) = bg_bw(k,j) + 1;           
             elseif (fr_bw(k,j) < bg_bw(k,j))
                 bg_bw(k,j) = bg_bw(k,j) - 1;     
             end
         end    
    end

% Threshold the image to get a binary image (only 0's and 1's) of class "logical."
% Method #1: using im2bw()
%   normalizedThresholdValue = 0.4; % In range 0 to 1.
%   thresholdValue = normalizedThresholdValue * max(max(originalImage)); % Gray Levels.
%   binaryImage = im2bw(originalImage, normalizedThresholdValue);       % One way to threshold to binary
% Method #2: using a logical operation.
  thresholdValue = 7;
  binaryImage = fg > thresholdValue; % Bright objects will be the chosen if you use >.
  % binaryImage = originalImage < thresholdValue; % Dark objects will be
  % the chosen if you use <.
% Do a "hole fill" to get rid of any background pixels inside the blobs.
% Perform errosion and dilation
binaryImage = imfill(binaryImage, 'holes');  
% set disk size for image operations
se = strel('disk',12);
se2 = strel('disk',4);
binaryImage = imopen(imclose(binaryImage,se),se2);

labeledImage = bwlabel(binaryImage, 8);     % Label each blob so we can make measurements of it
coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle'); % pseudo random color labels

% Get all the blob properties.  Can only pass in originalImage in version R2008a and later.
blobMeasurements = regionprops(labeledImage, fg, 'all');
numberOfBlobs = size(blobMeasurements, 1);

% Now I'll demonstrate how to select certain blobs based using the ismember function.
% Let's say that we wanted to find only those blobs 
% with an intensity between 150 and 220 and an area less than 2000 pixels.
% This would give us the three brightest dimes (the smaller coin type).
allBlobIntensities = [blobMeasurements.MeanIntensity]; 
allBlobAreas = [blobMeasurements.Area];
% Get a list of the blobs that meet our criteria and we need to keep. 
allowableIntensityIndexes = (allBlobIntensities > 150) & (allBlobIntensities < 220);
allowableAreaIndexes = allBlobAreas > 5500; % Take the large objects.
keeperIndexes = find(allowableAreaIndexes); 
% Extract only those blobs that meet our criteria, and 
% eliminate those blobs that don't meet our criteria. 
% Note how we use ismember() to do this.
keeperBlobsImage = ismember(labeledImage, keeperIndexes); 
% Re-label with only the keeper blobs kept.
labeledDimeImage = bwlabel(keeperBlobsImage, 8);     % Label each blob so we can make measurements of it
% Now we're done.  We have a labeled image of blobs that meet our specified criteria.

    figure(1),subplot(3,1,1),imshow(fr);
    subplot(3, 1, 2); imagesc(binaryImage); colormap(gray(256)); title('Binary Image, obtained by thresholding'); xlabel('');axis square ;
        for k = 1 : length(blobMeasurements)
            box = blobMeasurements(k).BoundingBox;
            if blobMeasurements(k).Area > 1
                hold on
                    rectangle('Position',box,'EdgeColor','b');
                hold off
            end
        end    
    subplot(3, 1, 3); 
    imshow(fr);
    title('"Keepers" what we believe that are actual cars');         
        if size(keeperIndexes) 
            for k = 1 : length(keeperIndexes)
                hold on
                box = blobMeasurements(keeperIndexes(k)).BoundingBox;
                    rectangle('Position',box,'EdgeColor','g');
                    hold off
                    blobMeasurements(keeperIndexes(k)).Area
                    
            end
                  'a'
        end
     %M(i-1)  = im2frame(uint8(fr),gray);             % save output as movie
     %M(i-1)  = im2frame(uint8(bg_bw),gray);             % save output as movie
end

 %movie2avi(M,'approximate_median_background2','fps',30);           % save movie as avi
