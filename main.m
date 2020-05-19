%% RUN
clear;

start = datetime('now');

neuralNet = DetectPlane('part2','USE',6);
%{
neuralNet = DetectPlane(filename, train_or_use, specified_net_index)

train_or_use = 
    'TRAIN' -> start a net from scratch
    'USE'   -> directly use an existing net
%}

finish = datetime('now');
Duration(start,finish);

%% SAVE
%{
exist = length(dir('./MaybeWellTrainedNets/*.mat'));
save(['./MaybeWellTrainedNets/neuralNet-',num2str(exist+1),'.mat'],'neuralNet');
%}