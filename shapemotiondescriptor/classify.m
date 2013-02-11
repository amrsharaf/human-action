% Fit a model according to the trainging data and calculate the correct
% classification rate for the testing data
function [correct_rate] = classify(train, test)
	% Classify the test data, use training data to create the model
	labels = knnclassify(test(:,1:end-1), train(:,1:end-1), train(:,end));
	% Calculate classifier performance metrics
	%cp = classperf(test(:,end),labels);
	%correct_rate = cp.CorrectRate;
	if labels == test(:,end)
		correct_rate = 1
	else
		correct_rate = 0
	end
end
