% This m-file implements the approximate median algorithm for background
% subtraction.  It may be used free of charge for any purpose (commercial
% or otherwise), as long as the author (Seth Benton) is acknowledged.
clear all
Frames = [];
Training = [];
Group = [];
Sample = [];
Label = [];
base_dir = '../weizmann_part/videos/';
activity = {'jump', 'run', 'walk'};
for c=1:length(activity)
	for ii=1:3
		source = aviread(strcat(base_dir,activity{c},int2str(ii)));
		% process frames
		Frames = [];
		for i = 1:length(source)
		    fr = source(i).cdata;
		    Frames(:,:,i)=rgb2gray(fr);
		end
		c
		ii
		'done with video'
		%[VX, VY] = lk3(Frames);
		[VX, VY] = OpticalFlow(Frames, 30,1);
		'done with optical flow'
		sz = size(VX)
		for k = 1 : sz(3)
			figure(1), subplot(2,1,1), imshow(source(k).cdata);
			subplot(2,1,2);
			imshow(source(k).cdata);
			hold on;
			quiver(-VX(:,:,k),-VY(:,:,k),0);	
			hold off
			ohog = gradientHistogram(VX(:,:,k), VY(:,:,k), 32);
			if ii ~= 3 
				Training = [Training; ohog'];
				Group = [Group; c];
			else
				Sample = [Sample; ohog'];
				Label = [Label; c];
			end
		end
	end
end
c = knnclassify(Sample, Training, Group);
cp = classperf(Label,c);
%get(cp)
cp.CountingMatrix
table = cp.DiagnosticTable;
tp = table(1,1)
fp = table(1,2)
tn = table(2,1)
fn = table(2,2)
precision = tp / (tp + fp) 
recall = tp / (tp + fn)
error_rate = cp.ErrorRate

