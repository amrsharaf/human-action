% This m-file implements the approximate median algorithm for background
% subtraction.  It may be used free of charge for any purpose (commercial
% or otherwise), as long as the author (Seth Benton) is acknowledged.
clear all
Frames = [];
Training = [];
Group = [];
Sample = [];
base_dir = '../weizmann_part/videos/';
activity = {'jump', 'run', 'walk'};
for c=1:length(activity)
	for ii=1:3
		source = aviread(strcat(base_dir,activity{c},int2str(ii)));
		% process frames
		for i = 1:length(source)
		    fr = source(i).cdata;
		    Frames(:,:,i)=rgb2gray(fr);
		end
		c
		ii
		'done with video'
		%[VX, VY] = lk3(Frames);
		[VX, VY] = OpticalFlow(Frames, 30, 1);
		'done with optical flow'
		sz = size(VX)
		for k = 1 : sz(3)
			ohog = gradientHistogram(VX(:,:,k), VY(:,:,k), 32);
			if ii ~= 3 
				Training = [Training; ohog'];
				Group = [Group; c];
			else
				Sample = [Sample; ohog'];
			end
		end
	end
end
class = knnclassify(Sample, Training, Group)
