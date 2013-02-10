function describe_videos()
	% loading videos
	addpath('../src');
	%addpath('../time_warping');
	rgb_videos = videos_loader();
	videos = load('../weizmann/classification_masks.mat');
	aligned_videos = videos.aligned_masks;
	% list all video names
	names = fieldnames(rgb_videos); 
	videos = struct;
	% for all videos
	%for i = 1:numel(names)
	for i = 1:1
		% Process a new  video
		vdes = [];% video descriptor
    		rgb_video = rgb_videos.(names{i});
		names{i}
		aligned_video = aligned_videos.(names{i});
		sz = size(aligned_video);
		nframes = sz(3);
		%for j = 1: 40: nframes-1
		for j = 1:1
			[shapedes, motiondes] = extract_features(aligned_video(:,:,j), rgb_video(j).cdata, rgb_video(j+1).cdata);
			des = [shapedes motiondes];
			vdes = horzcat(vdes, des');
		end
		'setting field'
		videos = setfield(videos, names{i}, vdes);
		'done setting field'
		videos
		whos videos
	end
	%save('described_videos.mat','videos');
end

