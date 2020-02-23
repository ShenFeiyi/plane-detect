function [I, label] = ImageRead(path, index)
%{

return a random or selected image 
label => target output o1
o1 -> is plane  1 not plane 0

%}

    patht = './img/is_plane/';
    pathf = './img/not_plane/';
    
    if nargin == 0
        index = ceil(rand()*64);

        if rand() >= 0.49999
            path = patht;
            label = 1;
        else
            path = pathf;
            label = 0;
        end
    else
        if strcmp(path, patht)
            label = 1;
        elseif strcmp(path, pathf)
            label = 0;
        else
            label = nan;
        end
    end
    
    pic = [path,num2str(index),'.tif'];
    
    I = imread(pic);

end