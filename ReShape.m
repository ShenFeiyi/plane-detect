function vector = ReShape(I)
%{

I = [a,a,a,a,a;
    b,b,b,b,b;
    c,c,c,c,c];

vector = [a;a;a;a;a;b;b;b;b;b;c;c;c;c;c];

%}

    m = size(I,1);
    n = size(I,2);

    vector = [];

    for i = 1:m
        vector((i-1)*n+1:i*n) = I(i,:);
    end

end