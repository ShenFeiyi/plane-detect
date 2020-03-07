function bw = Logical2bw(L)
    bw(1:size(L,1),1:size(L,2)) = 0;
    for i = 1:size(L,1)
        for j = 1:size(L,2)
            if L(i,j)
                bw(i,j) = 255;
            else
                bw(i,j) = 0;
            end
        end
    end
end