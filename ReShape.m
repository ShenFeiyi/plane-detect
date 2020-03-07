function package = ReShape(I,row)
%{

package = ReShape(I)
    I = [a,a,a,a,a;
         b,b,b,b,b;
         c,c,c,c,c];
    package = [a;a;a;a;a;b;b;b;b;b;c;c;c;c;c];

package = ReShape(I,row)
    I = [a;a;a;a;a;b;b;b;b;b;c;c;c;c;c];
    package = [a,a,a,a,a;
               b,b,b,b,b;
               c,c,c,c,c];
%}
    package = [];
    
    if nargin == 1
        m = size(I,1);
        n = size(I,2);
        for i = 1:m
            package((i-1)*n+1:i*n) = I(i,:);
        end
    else
        col = ceil(size(I,1)*size(I,2)/row);
        package(1:row,1:col) = 0;
        I = ReShape(I);
        for i = 1:row
            package(i,:) = I((i-1)*col+1:i*col);
        end
    end

end