function describe_videos()
	% loading videos
	addpath('../src');
	rgb_videos = videos_loader();
	videos = load('../weizmann/classification_masks.mat');
	aligned_videos = videos.aligned_masks;
	original_videos = videos.original_masks;
	% list all video names
	names = fieldnames(rgb_videos); 
	videos = struct;
	% for all videos
	counter = 0;
	for i = 1:numel(names)
		% Process a new  video
		vdes = [];% video descriptor
    		rgb_video = rgb_videos.(names{i});
		names{i}
		aligned_video = aligned_videos.(names{i});
		original_video = original_videos.(names{i});
		sz = size(aligned_video);
		nframes = sz(3);
		for j = 1: nframes-1
			[shapedes, motiondes] = extract_features(aligned_video(:,:,j), original_video(:,:,j), rgb_video(j).cdata, rgb_video(j+1).cdata);
			des = [shapedes motiondes];
			vdes = horzcat(vdes, des');
		end
		videos = setfield(videos, names{i}, vdes);
		counter = counter + 1
	end
	'now saving'
	save described_videos2.mat -struct videos;
end
