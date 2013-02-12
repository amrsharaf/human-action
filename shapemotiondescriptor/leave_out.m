function leave_out()
	% start by loading videos
	'Loading videos ...'
	videos = load('described_videos.mat');
	'Videos loaded ...'
	names = fieldnames(videos); 
	datav = [];
	for i = 1:numel(names)
		% Process a new  video
		videoi = videos.(names{i});
		features = [];
		for j = 1:numel(names)
			videoj = videos.(names{j});
			% now you have two videos
			[Dist,D,k,w,score] = dtw(videoi, videoj);
			features = [features score];
		end
		% now add class as the last column
		features = [features get_class(names{i})];
		datav = [datav; features];
	end
	'done with all videos'
	crossval(str2func('classify'),datav,'leaveout',1)
end

% This function assigns a unique id for each action from the dataset
function [classid] = get_class(str)
	if ~isempty(findstr(str,'bend'))
		classid = 1
	elseif ~isempty(findstr(str,'jack'))
		classid = 2
	elseif ~isempty(findstr(str, 'pjump'))
		classid = 4
	elseif ~isempty(findstr(str, 'jump'))
		classid = 3
	elseif ~isempty(findstr(str,'run'))
		classid = 5
	elseif ~isempty(findstr(str, 'side'))
		classid = 6
	elseif ~isempty(findstr(str, 'skip'))
		classid = 7
	elseif ~isempty(findstr(str,'walk'))
		classid = 8
	else
		classid = 9
	end
end
