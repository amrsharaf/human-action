function videos = videos_loader()
base_dir = '../weizmann/';
names = {'daria' 'denis' 'eli' 'ido' 'ira' 'lena' 'lyova' 'moshe' 'shahar'};
actions = {'bend' 'jack' 'jump' 'pjump' 'run' 'side' 'skip' 'walk' 'wave1' 'wave2'};
nnames = length(names);
nactions = length(actions);
videos = struct;
counter = 0;
for i = 1 : nnames
	for j = 1 : nactions
		if i ~= 6
			raw_video = aviread(strcat(base_dir, actions{j}, '/', names{i},'_', actions{j}));
			videos = setfield(videos, strcat(names{i}, '_', actions{j}), raw_video);
			counter = counter + 1;
		else
			% handle video for 'lena'
			if j == 5 | j == 7 | j == 8
				for k = 1:2
					raw_video = aviread(strcat(base_dir, actions{j}, '/', names{i}, '_', actions{j}, num2str(k)));
					videos = setfield(videos, strcat(names{i}, '_', actions{j}, num2str(k)), raw_video);
				counter = counter + 1;
				end
			else
				raw_video = aviread(strcat(base_dir, actions{j}, '/', names{i}, '_', actions{j}));
				videos = setfield(videos, strcat(names{i}, '_', actions{j}), raw_video);
				counter = counter + 1;
			end
		end
	end
end
end
