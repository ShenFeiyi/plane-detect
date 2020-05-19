function neuralNet = GiveMeAWellTrainedNet()
    error_max = 2;
    [neuralNet, error_number] = GiveMeANet();
    disp(['with error number = ',num2str(error_number)]);
    if error_number > error_max
        disp('Restart...');
    end
    while error_number > error_max
        [neuralNet, error_number] = GiveMeANet();
        disp(['with error number = ',num2str(error_number)]);
        if error_number > error_max
            disp('Restart...');
        end
    end
    disp('A well-trained net get.');
end