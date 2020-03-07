function [neuralNet, error_number] = GiveMeAnExcellentNet()
    patht = './img/is_plane/';
    pathf = './img/not_plane/';

    total_number = 64;
    training_number = 48;
    length = 121;

    input_train(training_number*2,length*length) = nan;
    target_train(training_number*2) = nan;

    for No = 1:training_number

        [I, label] = ImageRead(patht, No);
        input_train(2*No-1,:) = ReShape(I);
        target_train(2*No-1) = label;

        [I, label] = ImageRead(pathf, No);
        input_train(2*No,:) = ReShape(I);
        target_train(2*No) = label;

    end
    target_train = target_train';

    % try different layers for the best solution
    layers = [size(input_train,2),...
        round(size(input_train,1)/2),...
        round(size(input_train,1)/4),...
        1];

    iterations = 1e4-1;

    %%%%%%%%%%%%%%%%%%%%%     apply     %%%%%%%%%%%%%%%%%%%%%%%

    neuralNet = Train(Generate(layers), iterations, input_train, target_train);

    %%%%%%%%%%%%%%%%%%%%%     check     %%%%%%%%%%%%%%%%%%%%%%%

    checking_number = total_number - training_number;

    input_check(checking_number*2,length*length) = nan;
    target_check(checking_number*2,length*length) = nan;

    for No = 1:checking_number

        [I, label] = ImageRead(patht, No+training_number);
        input_check(2*No-1,:) = ReShape(I);
        target_check(2*No-1,:) = label;

        [I, label] = ImageRead(pathf, No+training_number);
        input_check(2*No,:) = ReShape(I);
        target_check(2*No,:) = label;

    end
    
    error_number = 0;

    for row = 1:size(input_check,1)
        [output, ~] = Apply(neuralNet, input_check(row, :));
        if (output < 0.5)&&(mod(row,2) == 1)
            error_number = error_number + 1;
        elseif (output >= 0.5)&&(mod(row,2) == 0)
            error_number = error_number + 1;
        end
    end

end