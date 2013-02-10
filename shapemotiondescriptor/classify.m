% Fit a model 
function [correct_rate] = classify(train, test)

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
labels = knnclassify(test.data, train.data, train.class);
cp = classperf(test.class,labels);
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

	videos = load('../weizmann/classification_masks.mat');
	aligned_videos = videos.aligned_masks;
	% list all video names
	names = fieldnames(rgb_videos); 
	videos = struct;

	%for i = 1:numel(names)
	for i = 1:5
		% Process a new  video
		vdes = [];
    		rgb_video = rgb_videos.(names{i});
		aligned_video = aligned_videos.(names{i});
		sz = size(aligned_video);
		nframes = sz(3);
		for j = 1: 40: nframes-1
		%for j = 1:2
			[shapedes, motiondes] = extract_features(aligned_video(:,:,j), rgb_video(j).cdata, rgb_video(j+1).cdata);
			des = [shapedes motiondes];
			vdes = horzcat(vdes, des');
		end
		videos = setfield(videos, names{i}, vdes);
		'done'
	end
	
	%for i = 1:numel(names)
	for i = 1:1 
		% Process a new  video
    		rgb_video = videos.(names{i});
		for j = 1:numel(names)
		%for j = 1:1
			aligned_video = videos.(names{j});
			% now you have two videos
			dtw(rgb_video,aligned_video)
		end
	end
	%video = aligned_videos.moshe_run;
	%video2 = rgb_videos.moshe_run;
	%sz = size(video);
	%sz2 = size(video2)
	% number of frames
	%nframes = sz(3);
	%for i = 10 : 10
	%	[shapedes, motiondes] = extract_features(video(:,:,i), video2(i).cdata, video2(i+1).cdata);
	%end
end
