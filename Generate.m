function neuralNet = Generate(layers)

% layers => vector of doubles 
% length => number of layers
% number => number of neurons 

	neuralNet = cell(1, length(layers)-1);
    
    for i = 1:length(layers)-1 % => for each
		neuralNet{i} = rand(layers(i),layers(i+1)).*2-1;
		% random in (-1,1); all connected
    end

end
