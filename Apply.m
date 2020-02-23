function [output, values] = Apply(neuralNet, input)
% input => a vector of input values

	values = cell(1, length(neuralNet)+1); % a, not z
    
    values{1} = input;

	for i = 1:length(neuralNet)
		values{i+1} = 1./(1+exp(-(values{i} * neuralNet{i})));
	end

	output = values{end}; % => final output

end
