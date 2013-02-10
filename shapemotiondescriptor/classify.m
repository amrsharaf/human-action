function [action] = classify(video)
	% loading videos
	addpath('../src');
	addpath('../time_warping');
	rgb_videos = videos_loader();
	videos = load('../weizmann/classification_masks.mat');
	aligned_videos = videos.aligned_masks;
	% list all video names
	names = fieldnames(rgb_videos); 
	videos = struct;

	%for i = 1:numel(names)
	for i = 1:1 
		% Process a new  video
		vdes = [];
    		rgb_video = rgb_videos.(names{i});
		aligned_video = aligned_videos.(names{i});
		sz = size(aligned_video);
		nframes = sz(3);
		%for j = 1: 40: nframes-1
		for j = 1:2
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
		%for j = 1:numel(names)
		for j = 1:1
			aligned_video = videos.(names{j});
			% now you have two videos
			whos rgb_video
			whos aligned_video
			[dtw_Dist, D, dtw_k, w, s1w, s2w] = dtw(rgb_video,aligned_video, 0)
			whos rgb_video
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
