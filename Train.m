function neuralNet = Train(neuralNet, iterations, input, target)

% input => a array of possible input vectors, e.g. [1,2;3,4;5,6]
% target => a array of expected output vectors, e.g. [0;1;1]

	learning_rate = 0.333;

	EPS = 1e-3; % total error value
	totalError = inf;
    
    disp('Training...');
    disp('Iteration = 1');
    disp(['Total error = ',num2str(totalError)]);
	for iter = 1:iterations
		sets = size(input, 1); % total number of samples
		totalError = totalError/sets;

		if mod(iter+1, 10) == 0
            disp(['Iterations = ', num2str(iter)]);
			disp(['Total error = ',num2str(totalError)]);
		end

		if totalError < EPS
			break;
		end

		totalError = 0; % reset 

		for set = 1:sets % for each sample
			t = target(set);

			[output, values] = Apply(neuralNet, input(set,:));
			totalError = totalError + abs(t-output)/sets; 
			% add up each absolute value of sample's error

			e = output - t;

			% back propagate 
			for i = length(neuralNet):-1:1
				% weight value between layer and layer; from last to first
				out = values{i+1}; % current layer's original output
				in = values{i}; % current layer's original input

				%delta = diag(out.*(1-out)).*e(:); % mathematical way 
				delta = out.*(1-out).*e'; % Matlab way
				% error(before backpropagate through weights)
                %  = derivative of output * error

				e = neuralNet{i} * delta'; % error(after backpropagate through weights)
				neuralNet{i} = neuralNet{i} - (learning_rate * in' * delta);
			end
		end
	end

	disp(['Stop training at ', num2str(iter),...
        ' iterations with a total error of ', num2str(totalError/sets)])

end