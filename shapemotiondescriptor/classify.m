function [action] = classify(video)
	% calculate discriptor for each frame
	% size of video height * width * frames
	videos = load('../weizmann/classification_masks.mat');
	aligned_masks = videos.aligned_masks;
	video = aligned_masks.moshe_run;
	sz = size(video);
	% number of frames
	nframes = sz(3);
	% loop and calculate discreptor for each frame
	for i = 1 : 1
	%for i = 1 : nframes-1
		% extract features for this frame
		[shapedes, motiondes] = extract_features(video(:,:,i), video(:,:,i+1));	
	end
end
