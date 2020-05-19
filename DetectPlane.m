function neuralNet = DetectPlane(filename, train_or_use, specified_net_index)
%{
input para:
    filename
        -> string
            a jpeg/png file's name without extension in folder ./img/

    train_or_use
        -> string
            'train' -> train_a_net = true
            'use'   -> train_a_net = false

    specified_net_index
        -> a number, uint8, double, whatever
            if want to use a specific net

output para:
    neuralNet
        -> cell
            the weight matrices; save it in case it is excellent
%}

    %{
        train_a_net
                -> logical
                    true -> retrain a net from scratch, may spend more time
                    false-> use an existed net
    %}

    existing_net_number = length(dir('./MaybeWellTrainedNets/*.mat'));
    if nargin == 1
        train_a_net = true;
    elseif nargin == 3
        index = specified_net_index;
    else
        index = ceil(rand()*existing_net_number);
    end
    
    flag_end = false;
    
    if strcmp(train_or_use,'TRAIN')
        train_a_net = true;
    elseif strcmp(train_or_use,'USE')
        train_a_net = false;
    else
        disp('support ''TRAIN'' or ''USE'' only!');
        neuralNet = cell(0);
        flag_end = true;
    end
    
    %%%%%%%%%%%%%%%%%%%%   well-trained net   %%%%%%%%%%%%%%%%%%%%
    try
        if train_a_net
            neuralNet = GiveMeAWellTrainedNet();
        else
            struct = load(['./MaybeWellTrainedNets/neuralNet-',num2str(index),'.mat']);
            neuralNet = struct.neuralNet;
        end
    catch
        %
    end
    
    disp('Detecting...');
    %%%%%%%%%%%%%%%%%%%%     practise     %%%%%%%%%%%%%%%%%%%%
    try
        I = imread(['./img/',filename,'.jpg']);
    catch
        I = imread(['./img/',filename,'.png']);
    end
    Gray = rgb2gray(I);
    background = imopen(Gray,strel('disk',8));
    Gray = imsubtract(Gray,background);
    Logi = imbinarize(Gray);
    BW = Logical2bw(Logi);

    width = 121;
    height = 121;
    % focus on center
    row_min = (height-1)/2+1;
    col_min = (width-1)/2+1;
    row_max = size(I,1) - row_min + 1;
    col_max = size(I,2) - col_min + 1;

    semi_row = (height-1)/2;
    semi_col = (width-1)/2;

    nrow = ceil(size(BW,1)/height);
    ncol = ceil(size(BW,2)/width);
    points(1:nrow*ncol,1:4) = 0; % points where planes are detected & theta & probability
    np = 0;

    plants = ColorRange('plants',0.15);
    soil = ColorRange('soil',0.03);
    road = ColorRange('paved_road',0.1);

    % 1st, scan the whole picture
    r = row_min;
    while true
        c = col_min;
        while true
            % 2nd, delete some area, including plants, soil & road
            condi_p = I(r,c,1)>=plants(1,1)&&I(r,c,1)<=plants(1,3);
            condi_p = condi_p&&I(r,c,2)>=plants(2,1)&&I(r,c,2)<=plants(2,3);
            condi_p = condi_p&&I(r,c,3)>=plants(3,1)&&I(r,c,3)<=plants(3,3);

            condi_s = I(r,c,1)>=soil(1,1)&&I(r,c,1)<=soil(1,3);
            condi_s = condi_s&&I(r,c,2)>=soil(2,1)&&I(r,c,2)<=soil(2,3);
            condi_s = condi_s&&I(r,c,3)>=soil(3,1)&&I(r,c,3)<=soil(3,3);

            condi_r = I(r,c,1)>=road(1,1)&&I(r,c,1)<=road(1,3);
            condi_r = condi_r&&I(r,c,2)>=road(2,1)&&I(r,c,2)<=road(2,3);
            condi_r = condi_r&&I(r,c,3)>=road(3,1)&&I(r,c,3)<=road(3,3);

            condition = condi_p || condi_s || condi_r;
            % planes are usually white
            condition = condition||(I(r,c,1)<200)||(I(r,c,2)<200)||(I(r,c,3)<200);

            if condition % plants, soil or road, then do nothing
            else
                % 3rd, check if there's a plane nearby
                n = 1;
                while points(n,1) > 0
                    while true
                        if (r-points(n,1)<=round(semi_row/1.5))&&...
                                (points(n,2)-c<=round(semi_col/1.5))
                            c = c + width;
                            if c > col_max
                                c = col_min;
                                r = r + 1;
                                if r > row_max
                                    r = r - 1;
                                    flag_end = true;
                                    break;
                                end
                            end
                        else
                            break;
                        end
                    end
                    n = n + 1;
                    if n > size(points,1)
                        break;
                    end
                    if flag_end
                        break;
                    end
                end 

                if flag_end
                    break;
                else
                    % 4th, check in every direction
                    P0 = BW(r-semi_row:r+semi_row,c-semi_col:c+semi_col);
                    dtheta = 1;
                    bingo = 10;
                    for theta = 0:dtheta:359
                        % rotate / if you can find the symmetric axis, better
                        P = imrotate(P0, theta, 'nearest', 'crop');
                        input = ReShape(P);
                        [output, ~] = Apply(neuralNet, input);
                        if output > 0.9
                            bingo = bingo - 1;
                        end

                        if bingo == 0
                            % plane detected / record row & column
                            np = np + 1;
                            points(np,1) = r;
                            points(np,2) = c;
                            points(np,3) = theta;
                            points(np,4) = output;

                            disp(['np = ',num2str(np),'; ',...
                                'r = ',num2str(r),'; ',...
                                'c = ',num2str(c),'; ',...
                                'theta = ',num2str(theta),'; ',...
                                'probability = ',num2str(output)]);

                            % impossible that 2 planes collide into each other
                            if (c+width) > col_max
                                c = col_min - 1; % c will +1 after break
                                r = r + 1;
                                if r > row_max
                                    r = r - 1;
                                    flag_end = true;
                                    break;
                                end
                            else
                                c = c + round(semi_col/1.5);
                            end

                            break;
                        end
                    end
                end
            end

            c = c + 1;
            if c >= col_max
                break;
            end
            if flag_end
                break;
            end
        end

        disp(['processing... ',num2str(round(10000*r/row_max)/100),'% ...']);

        r = r + 1;
        if r >= row_max
            break;
        end
        if flag_end
            break;
        end
    end
    disp('Detection Done');

    for each = 1:size(points,1)
        if points(each,1) == 0
            break;
        end
        imwrite(...
            imrotate(...
                BW(...
                    points(each,1)-semi_row:points(each,1)+semi_row,...
                    points(each,2)-semi_col:points(each,2)+semi_col),...
                points(each,3),'nearest','crop'),...
            ['./img/detect/detect-',...
            num2str(each),'-',...
            num2str(points(each,3)),'˚-',...
            num2str(points(each,4)*100),'%','.tif']);
        imwrite(...
            BW(...
                points(each,1)-semi_row:points(each,1)+semi_row,...
                points(each,2)-semi_col:points(each,2)+semi_col),...
            ['./img/detect/detect-',...
            num2str(each),'-',...
            '0˚-',...
            num2str(points(each,4)*100),'%','.tif']);
    end

    disp('Start tagging...');
    line_width = 3;

    imshow(I);
    hold on
    for index = 1:size(points,1)
        if points(index,1) > 0
            rectangle(...
                'Position',...
                [points(index,2)-semi_col,points(index,1)-semi_row,height,width],...
                'Curvature',[0,0],'EdgeColor','r','LineWidth',line_width);
        end
    end
    hold off
    time = datetime('now');
    saveas(gcf,['./img/result/','result-',filename,'-',...
        num2str(time.Year),'-',num2str(time.Month),'-',num2str(time.Day),'-',...
        num2str(time.Hour),'-',num2str(time.Minute),'-',num2str(time.Second),'.tif']);

    disp('DONE!');
end