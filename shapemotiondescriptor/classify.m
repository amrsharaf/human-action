function [action] = classify(video)
	% calculate discriptor for each frame
	% size of video height * width * frames
	sz = size(video);
	% number of frames
	nframes = sz(3);
	% loop and calculate discreptor for each frame
	for i = 1 : nframes-1
		% extract features for this frame
		[shapedes, motiondes] = demo_code(video(:,:,i), video(:,:,i+1));	
	end
end
