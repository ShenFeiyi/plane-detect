function bw = Gray2BW(gray, threshold)
    bw = gray;
    for row = 1:size(gray,1)
        for column = 1:size(gray,2)
            if gray(row,column) > threshold
                bw(row,column) = 255;
            else
                bw(row,column) = 0;
            end
        end
    end
end