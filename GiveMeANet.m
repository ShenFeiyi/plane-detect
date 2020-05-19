function [neuralNet, error_number] = GiveMeANet()

    %%%%%%%%%%%%%%%%%%%%%     prepare     %%%%%%%%%%%%%%%%%%%%%%%

    patht = './img/is_plane/';
    pathf = './img/not_plane/';

    total_number_t = length(dir('./img/is_plane/*.tif'));
    total_number_f = length(dir('./img/not_plane/*.tif'));
    training_number_t = round(0.8*total_number_t);
    training_number_f = round(0.8*total_number_f);
    width = 121;

    input_train(1:training_number_t+training_number_f,1:width*width) = nan;
    target_train(1:training_number_t+training_number_f) = nan;
    
    input_train_t(1:training_number_t,1:width*width) = nan;
    target_train_t(1:training_number_t) = nan;
    input_train_f(1:training_number_f,1:width*width) = nan;
    target_train_f(1:training_number_f) = nan;

    for No = 1:training_number_t
        [I, label] = ImageRead(patht, No);
        input_train_t(No,:) = ReShape(I);
        target_train_t(No) = label;
    end
    for No = 1:training_number_f
        [I, label] = ImageRead(pathf, No);
        input_train_f(No,:) = ReShape(I);
        target_train_f(No) = label;
    end
    
    input_train(1:training_number_t,:) = input_train_t;
    input_train(training_number_t+1:training_number_t+training_number_f,:) = input_train_f;
    target_train(1:training_number_t) = target_train_t;
    target_train(training_number_t+1:training_number_t+training_number_f) = target_train_f;
    target_train = target_train';

    iterations = 1e5-1;
    
    %%%%%%%%%%%%%%%%%%%%%     train     %%%%%%%%%%%%%%%%%%%%%%%

    % try different layers for the best solution
    layers = [size(input_train,2),...
        round(size(input_train,1)/2),...
        round(size(input_train,1)/4),...
        round(size(input_train,1)/8),...
        2,...
        1];

    neuralNet = Train(Generate(layers), iterations, input_train, target_train);


    %%%%%%%%%%%%%%%%%%%%%     check     %%%%%%%%%%%%%%%%%%%%%%%

    checking_number_t = total_number_t - training_number_t;
    checking_number_f = total_number_f - training_number_f;

    input_check(1:checking_number_t+checking_number_f,1:width*width) = nan;
    target_check(1:checking_number_t+checking_number_f) = nan;
    
    input_check_t(1:checking_number_t,1:width*width) = nan;
    target_check_t(1:checking_number_t) = nan;
    input_check_f(1:checking_number_f,1:width*width) = nan;
    target_check_f(1:checking_number_f) = nan;

    for No = checking_number_t:-1:1
        [I, label] = ImageRead(patht, total_number_t-No+1);
        input_check_t(No,:) = ReShape(I);
        target_check_t(No) = label;
    end
    for No = checking_number_f:-1:1
        [I, label] = ImageRead(pathf, total_number_f-No+1);
        input_check_f(No,:) = ReShape(I);
        target_check_f(No) = label;
    end
    
    input_check(1:checking_number_t,:) = input_check_t;
    input_check(checking_number_t+1:checking_number_t+checking_number_f,:) = input_check_f;
    target_check(1:checking_number_t) = target_check_t;
    target_check(checking_number_t+1:checking_number_t+checking_number_f) = target_check_f;
    target_check = target_check';
    
    error_number = 0;

    for row = 1:size(input_check,1)
        [output, ~] = Apply(neuralNet, input_check(row, :));
        if (output < 0.4)&&(target_check(row) == 1)
            error_number = error_number + 1;
        elseif (output >= 0.6)&&(target_check(row) == 0)
            error_number = error_number + 1;
        end
    end
end