clear;

%%%%%%%%%%%%%%%%%%%%   well-trained net   %%%%%%%%%%%%%%%%%%%%
error_max = 1;
[neuralNet, error_number] = GiveMeAnExcellentNet();
disp(['with error number = ',num2str(error_number)]);
if error_number > error_max
    disp('Restart...');
end
while error_number > error_max
    [neuralNet, error_number] = GiveMeAnExcellentNet();
    disp(['with error number = ',num2str(error_number)]);
    if error_number > error_max
        disp('Restart...');
    end
end

disp('A well-trained net get.');

disp('Detecting...');

%%%%%%%%%%%%%%%%%%%%     practise     %%%%%%%%%%%%%%%%%%%%
I = imread('./img/part1.jpg');
Gray = rgb2gray(I);
background = imopen(Gray,strel('disk',8));
Gray = imsubtract(Gray,background);
Logi = imbinarize(Gray);
BW = Logical2bw(Logi);

width = 121;
height = 121;
% focus on the (1,1) pixel 
row_min = 1;
row_max = size(BW,1)-height+1;
col_min = 1;
col_max = size(BW,2)-width+1;

nrow = ceil(size(BW,1)/height);
ncol = ceil(size(BW,2)/width);
points(1:nrow*ncol,1:2) = 0; % points where planes are detected % global para
np = 0;
centroids(1:nrow*ncol,1:2) = 0; % local para
bounds(1:nrow*ncol,1:4) = 0; % local para
areas(1:nrow*ncol) = 0; % local para
nc = 0;
nb = 0;
na = 0;

flag_end = false;
P0(1:width,1:height) = 0;
r = row_min;
while true
    c = col_min;
    while true
        % 1st, scan the whole picture
        % 2nd, check if there's a plane nearby
        n = 1;
        while points(n,1) > 0
            while true
                if (r-points(n,1)<=height)&&(points(n,2)-c<=width)
                    c = c + 2*width;
                    if c > col_max
                        c = 1;
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
        
        % 3rd, check in every direction
        P0 = BW(r:r-1+height,c:c-1+width);
        output(1:36) = 0;
        for theta = 0:35
            % rotate / if you can find the symmetric axis, better
            P = imrotate(P0, theta, 'nearest', 'crop');
            input = ReShape(P);
            [output(theta+1), ~] = Apply(neuralNet, input);
        end
        aver = 0;
        output = output/(theta+1);
        for each = 1:theta+1
            aver = aver + output(each);
        end
        if aver > 0.456
            % plane detected / record row & column
            np = np + 1;
            points(np,1) = r;
            points(np,2) = c;

            disp(['np = ',num2str(np),'; ','r = ',num2str(r),'; ','c = ',num2str(c)]);

            % record boundary & centroid 
            L = Logi(r:r-1+height,c:c-1+width);
            ctd = regionprops(L, 'centroid');
            bnd = regionprops(L, 'BoundingBox');
            arc = regionprops(L, 'area');
            centroid = cat(1, ctd.Centroid);
            bound = cat(1, bnd.BoundingBox);
            area = cat(1, arc.Area);
            % a plane with many pieces, the biggest -> plane
            index = 1;
            area_max = area(index);
            for n = 2:size(area,1)
                area_temp = area(n);
                if area_temp > area_max
                    index = n;
                    area_max = area_temp;
                end
            end
            nc = nc + 1;
            nb = nb + 1;
            na = na + 1;
            centroids(nc,:) = centroid(index,:) + [r,c];
            bounds(nb,:) = bound(index,:) + [r,c,0,0];
            areas(na) = area(index);
            
            disp(['na = ',num2str(na),'; ','area = ',num2str(areas(na))]);
            disp(['nb = ',num2str(nb),'; ','bounds1~4 = ',num2str(bounds(nb,1)),'; ',...
                num2str(bounds(nb,2)),';  ',num2str(bounds(nb,3)),'; ',num2str(bounds(nb,4))]);
            disp(['nc = ',num2str(nc),'; ','centriod12 = ',...
                num2str(centroids(nc,1)),'; ',num2str(centroids(nc,2))]);

            % impossible that 2 planes collide into each other
            if (c+width) > col_max
                c = 1;
                r = r + 1;
                if r > row_max
                    r = r - 1;
                    flag_end = true;
                    break;
                end
            else
                c = c + round(width/2);
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
    if (points(each,1)+height<size(BW,1))&&(points(each,2)+width<size(BW,2))
        imwrite(BW(points(each,1):points(each,1)+height,points(each,2):points(each,2)+width),...
            ['./img/detect/detect-',num2str(each),'.tif']);
        
    elseif (points(each,1)+height>=size(BW,1))&&(points(each,2)+width<size(BW,2))
        imwrite(BW(points(each,1):size(BW,1),points(each,2):points(each,2)+width),...
            ['./img/detect/detect-',num2str(each),'.tif']);
        
    elseif (points(each,1)+height<size(BW,1))&&(points(each,2)+width>=size(BW,2))
        imwrite(BW(points(each,1):points(each,1)+height,points(each,2):size(BW,2)),...
            ['./img/detect/detect-',num2str(each),'.tif']);
        
    else
        imwrite(BW(points(each,1):size(BW,1),points(each,2):size(BW,2)),...
            ['./img/detect/detect-',num2str(each),'.tif']);
    end
end

disp('Start tagging...');
line_width = 5;

imshow(I);
hold on
for index = 1:size(points,1)
    if points(index,1) > 0
        rectangle('Position',[points(index,2),points(index,1),bounds(index,3),...
            bounds(index,4)],'Curvature',[0,0],'EdgeColor','b','LineWidth',line_width);
        rectangle('Position',[points(index,2),points(index,1),height,width],...
            'Curvature',[0,0],'EdgeColor','r','LineWidth',line_width);
    end
end
hold off

disp('DONE!');