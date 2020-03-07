% return iteration way to calculate threshold
%{
             /  T                         \
             |   i              L-1       |
             |  Σ  hk * k        Σ hk * k |
           1 | k=0           k = Ti + 1   |
    T    = - | ----------- + -------------|
     i+1   2 |     T            L-1       |
             |      i            Σ hk     |
             |     Σ hk      k = Ti + 1   |
             \    k=0                     /
%}
% L: maximum of gray value, default 255

% let Ti+1 = 1/2(A/B+C/D)

function t = iter_thres(g)

% histogram / a list
hg(1:256) = 0;
for i = 1:size(g,1)
    for j = 1:size(g,2)
        hg(g(i,j)+1) = hg(g(i,j)+1) + 1;
    end
end

% iteration threshold
T = 200;
Ti = 127;
while 1
    A = 0;
    B = 0;
    for k = 0:Ti
        A = A + k*hg(k+1);
        B = B + hg(k+1);
    end
    C = 0;
    D = 0;
    for k = Ti+1:255
        C = C + k*hg(k+1);
        D = D + hg(k+1);
    end
    Ti = 1/2*(A/B+C/D);
    if floor(T) == floor(Ti)
        break;
    end
    Ti = floor(Ti);
    T = Ti;
end

t = T;