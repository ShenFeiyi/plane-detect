%% tag centers, draw boundaries
clear;
BW0 = logical(imread('./img/sample_p.tif'));

c = regionprops(BW0,'centroid');
b = regionprops(BW0,'BoundingBox');
a = regionprops(BW0,'area');

centroids = cat(1, c.Centroid);
bounds = cat(1, b.BoundingBox);
areas = cat(1, a.Area);

imshow(BW0);
hold on
plot(centroids(:,1),centroids(:,2),'b*');
for i = 1:size(bounds,1)
    plot(bounds(i,1):bounds(i,1)+bounds(i,3),bounds(i,2),'ro',...
        bounds(i,1):bounds(i,1)+bounds(i,3),bounds(i,2)+bounds(i,4),'ro',...
        bounds(i,1),bounds(i,2):bounds(i,2)+bounds(i,4),'ro',...
        bounds(i,1)+bounds(i,3),bounds(i,2):bounds(i,2)+bounds(i,4),'ro');
end
hold off
for i = 1:length(c(:))
    disp(c(i));
end


%% centroids boundaries
clear;

BW0 = imread('./img/rice.png');
for i = 1:size(BW0,1)
    for j = 1:size(BW0,2)
        if BW0(i,j) > 100
            BW0(i,j) = 255;
        else
            BW0(i,j) = 0;
        end
    end
end
BW0 = logical(BW0);
P = imread('text.png');

c = regionprops(BW0,'centroid');
b = regionprops(BW0,'BoundingBox');
a = regionprops(BW0,'area');

centroids = cat(1, c.Centroid);
bounds = cat(1, b.BoundingBox);
areas = cat(1, a.Area);

imshow(BW0);
hold on
plot(centroids(:,1),centroids(:,2),'b*');
for i = 1:size(bounds,1)
    plot(bounds(i,1):bounds(i,1)+bounds(i,3),bounds(i,2),'ro',...
        bounds(i,1):bounds(i,1)+bounds(i,3),bounds(i,2)+bounds(i,4),'ro',...
        bounds(i,1),bounds(i,2):bounds(i,2)+bounds(i,4),'ro',...
        bounds(i,1)+bounds(i,3),bounds(i,2):bounds(i,2)+bounds(i,4),'ro');
end
hold off
for i = 1:length(c(:))
    disp(c(i));
end

%% rotate
BW0 = imread('./img/sample_p.tif');
subplot(1,2,2);
P1 = imrotate(BW0,45,'nearest','crop');
disp([num2str(size(P1,1)),' ',num2str(size(P1,2))]);
imshow(P1);
subplot(1,2,1);
disp([num2str(size(BW0,1)),' ',num2str(size(BW0,2))]);
imshow(BW0);

%% find the symmetrical axis, failed
clear;

BW0 = logical(imread('./img/sample_p.tif'));
subplot(1,2,1);
imshow(BW0);

% original image, center, length width, the biggest is plane
c = regionprops(BW0,'centroid');
b = regionprops(BW0,'BoundingBox');
centers = cat(1, c.Centroid);
bounds = cat(1, b.BoundingBox);
len_max = bounds(1,3);
wid_max = bounds(1,4);
for i = 2:size(bounds,1)
    if bounds(i,3) > len_max
        len_max = bounds(i,3);
    end
    if bounds(i,4) > wid_max
        wid_max = bounds(i,4);
    end
end
area_max = len_max * wid_max;

% rotate image, biggest is plane
dtheta = 8;
theta = 0;
BW = BW0;
while true
    area_temp = 0;
    theta = theta + dtheta;
    if theta > 90
        break;
    end
    
    BW = imrotate(BW, theta, 'nearest', 'crop');
    c = regionprops(BW,'centroid');
    b = regionprops(BW,'BoundingBox');
    centers = cat(1, c.Centroid);
    bounds = cat(1, b.BoundingBox);
    len_temp = bounds(1,3);
    wid_temp = bounds(1,4);
    for i = 2:size(bounds,1)
        if bounds(i,3) > len_temp
            len_temp = bounds(i,3);
        end
        if bounds(i,4) > wid_temp
            wid_temp = bounds(i,4);
        end
    end
    area_temp = len_temp * wid_temp;
    
    if area_temp < area_max
        theta = theta - dtheta;
        BW = imrotate(BW0, theta, 'nearest', 'crop');
        c = regionprops(BW,'centroid');
        b = regionprops(BW,'BoundingBox');
        centers = cat(1, c.Centroid);
        bounds = cat(1, b.BoundingBox);
        len_max = bounds(1,3);
        wid_max = bounds(1,4);
        for i = 2:size(bounds,1)
            if bounds(i,3) > len_max
                len_max = bounds(i,3);
            end
            if bounds(i,4) > wid_max
                wid_max = bounds(i,4);
            end
        end
        area_max = len_max * wid_max;
        break;
    end
end

subplot(1,2,2);
imshow(BW);

%%
for i = 1:10
    if i == 3
        i = 7;
    end
    disp(i);
end

%%
clear;
A(1:100,1:100,1:3) = 0;
A(:,:,1) = 255;
A(:,:,2) = 122;

t(1:3,1:3) = 0;

for i = 1:100
    A(49:51,i,:) = t;
end

for i = 1:100
    A(i,49:51,:) = t;
end

imshow(A);

%%
clear;
A(1:100,1:100,1:3) = 0;
A(1:100,1:100,2) = 10;
A(1:100,1:100,3) = 10;
imshow(A);
hold on
rectangle('Position',[10,20,30,40],'Curvature',[0,0],...
    'EdgeColor','r','LineWidth',2);
hold off

%% threshold 
clear;

I1 = imread('./img/part3.jpg');
I2 = imread('./img/part2.jpg');

Gray1 = rgb2gray(I1);
Gray2 = rgb2gray(I2);

sum1 = 0;
for i = 1:size(Gray1,1)
    for j = 1:size(Gray1,2)
        sum1 = sum1 + double(Gray1(i,j));
    end
end
aver1 = sum1 / (size(Gray1,1)*size(Gray1,2));
disp(['average = ',num2str(aver1),';']);

sum2 = 0;
for i = 1:size(Gray2,1)
    for j = 1:size(Gray2,2)
        sum2 = sum2 + double(Gray2(i,j));
    end
end
aver2 = sum2 / (size(Gray2,1)*size(Gray2,2));

figure(1);
subplot(2,2,1);
histogram(I1);
title(['average',num2str(aver1)]);
subplot(2,2,2);
histogram(I2);
title(['average',num2str(aver2)]);
subplot(2,2,3);
imshow(Gray1);
subplot(2,2,4);
imshow(Gray2);

figure(2);
subplot(2,2,1);
imshow(I1);
subplot(2,2,2);
imshow(Gray1);

P1 = Gray1;
for i = 1:size(Gray1,1)
    for j = 1:size(Gray1,2)
        if Gray1(i,j) > 200
            P1(i,j) = 255;
        else
            P1(i,j) = 0;
        end
    end
end
subplot(2,2,3);
imshow(P1);
title('manual threshold 200');

thres = iter_thres(Gray1);
disp(['threshold = ',num2str(thres),';']);
P2 = Gray1;
for i = 1:size(Gray1,1)
    for j = 1:size(Gray1,2)
        if Gray1(i,j) > thres
            P2(i,j) = 255;
        else
            P2(i,j) = 0;
        end
    end
end
subplot(2,2,4);
imshow(P2);
title(['algorithm threshold',num2str(thres)]);

%%
clear;

I = imread('./img/part3.jpg');
gray = rgb2gray(I);

subplot(2,2,1);
imshow(gray);

bg = imopen(gray,strel('disk',8));

subplot(2,2,2);
imshow(bg);

p = imsubtract(gray,bg);
subplot(2,2,3);
imshow(p);

thres = iter_thres(p);
disp(['threshold = ',num2str(thres),';']);

for i = 1:size(p,1)
    for j = 1:size(p,2)
        if p(i,j) > thres
            p(i,j) = 255;
        else
            p(i,j) = 0;
        end
    end
end

subplot(2,2,4);
imshow(p);

%% make training set, no matter how bad it looks, use the exact same processes when detecting
clear;

I = imread('./img/20170731-侧摆角(17.0626)-美国-西雅图-塔科马国际机场.jpg');
gray = rgb2gray(I);
bg = imopen(gray,strel('disk',8));
sub = imsubtract(gray,bg);

imwrite(sub,'./img/sub.tif');

%% make training set, no matter how bad it looks, use the exact same processes when detecting
clear;

index = 63;
theta = 11;

I = imread(['./img/rotate/',num2str(index),'.tif']);

I = imrotate(I,theta,'nearest','crop');

imwrite(I,['./img/up/',num2str(index),'.tif']);

disp([num2str(index),'done']);

%% 
clear;

for i = 1:9
    gray = imread(['./img/is_plane/',num2str(ceil(64*rand)),'.tif']);
    l = imbinarize(gray);
    bw = Logical2bw(l);
    subplot(3,3,i);
    imshow(bw);
end

%% 
clear;

for i = 1:64
    gray = imread(['./img/is_plane/',num2str(i),'.tif']);
    l = imbinarize(gray);
    bw = Logical2bw(l);
    imwrite(bw,['./img/is_plane/',num2str(i),'.tif']);
end
for i = 1:64
    gray = imread(['./img/not_plane/',num2str(i),'.tif']);
    l = imbinarize(gray);
    bw = Logical2bw(l);
    imwrite(bw,['./img/not_plane/',num2str(i),'.tif']);
end

%%
clear;
num = 63;
gray = imread(['./img/backup/rotate/',num2str(num),'.tif']);
l = imbinarize(gray);
bw = Logical2bw(l);
imwrite(bw,['./img/sample2/',num2str(num),'.tif']);

%% even not a plane, the probability may > 0.5
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

sample01 = imread('./img/aasample/36/sample_p.tif');
sample02 = imread('./img/aasample/36/sample_n.tif');
output1(1:360) = 0;
output2(1:360) = 0;
for angle = 0:359
    sample1 = imrotate(sample01,angle,'nearest','crop');
    sample2 = imrotate(sample02,angle,'nearest','crop');
    input1 = ReShape(sample1);
    input2 = ReShape(sample2);
    [output1(angle+1),~] = Apply(neuralNet,input1);
    [output2(angle+1),~] = Apply(neuralNet,input2);
end

aver1 = 0;
aver2 = 0;
for angle = 0:359
    aver1 = aver1 + output1(angle+1);
    aver2 = aver2 + output2(angle+1);
end
aver1 = aver1 / 360;
aver2 = aver2 / 360;

plot(1:360,output1,'ro-',1:360,output2,'bo-',1:360,0.5,'g*');
legend('positive sample','negative sample');
title(['旋转一周输出曲线',', aver-p = ',num2str(aver1),', aver-n = ',num2str(aver2)]);

%% hollow
clear;

for img = 1:64
    I = imread(['./img/is_plane/',num2str(img),'.tif']);
    r0 = 61;
    c0 = 61;
    Radius = 9;
    for r = 1:121
        for c = 1:121
            if ((power(r-r0,2)+power(c-c0,2))<=power(Radius,2))&&(I(r,c)>0)
                I(r,c) = I(r,c) - 155;
            end
        end
    end
    imwrite(I,['./img/is_plane/',num2str(img),'.tif']);
end
disp('done');

%% 36*10 samples // ! time consuming !!!
clear;

p = [0.56045,0.62276,0.58905,0.46776,0.59238,0.67124,0.47531,0.5531,0.51486,0.49317;
    0.26439,0.25395,0.18884,0.16554,0.22668,0.34274,0.30621,0.18429,0.19764,0.12597;
    0.30876,0.36513,0.37962,0.32509,0.29206,0.32977,0.28455,0.43467,0.3721,0.281020;
    0.15882,0.14315,0.12896,0.15313,0.1243,0.20656,0.20511,0.16218,0.1304,0.1832;
    0.57692,0.52719,0.46116,0.55444,0.479,0.5651,0.40734,0.57434,0.70987,0.65178;
    0.65107,0.65899,0.86273,0.68736,0.75383,0.60752,0.51513,0.61568,0.50024,0.68429;
    % 6
    0.37585,0.33766,0.36496,0.34143,0.41483,0.37959,0.4962,0.45267,0.42982,0.41547;
    0.41002,0.36866,0.37576,0.25329,0.45642,0.35013,0.48321,0.49444,0.45824,0.53369;
    0.25985,0.33282,0.34228,0.3475,0.31328,0.4342,0.4448,0.29017,0.33686,0.27987;
    0.40105,0.43563,0.50747,0.49386,0.37321,0.35121,0.5964,0.36979,0.5328,0.35954;
    0.52113,0.56161,0.43589,0.57124,0.48466,0.54612,0.56411,0.50362,0.45796,0.51524;
    0.31449,0.39252,0.41964,0.4319,0.19044,0.3829,0.36712,0.46021,0.30685,0.3109;
    % 12
    0.68044,0.72058,0.61203,0.74147,0.79921,0.71621,0.4844,0.68562,0.51124,0.61975;
    0.28149,0.27141,0.29045,0.19806,0.31912,0.43842,0.23517,0.34399,0.30545,0.25176;
    0.29454,0.42037,0.40817,0.40578,0.3947,0.39891,0.3463,0.42494,0.31742,0.32847;
    0.41416,0.48824,0.42731,0.42101,0.57107,0.43835,0.47949,0.50366,0.25991,0.37309;
    0.59235,0.55856,0.52529,0.50299,0.52262,0.44425,0.57822,0.49124,0.59383,0.68266;
    0.53199,0.40984,0.41154,0.3961,0.4732,0.27865,0.42044,0.45915,0.48097,0.50682;
    % 18
    0.36423,0.38759,0.40147,0.40197,0.45792,0.45919,0.35761,0.41315,0.31181,0.32923;
    0.6173,0.41643,0.50867,0.48122,0.58943,0.63138,0.48154,0.56766,0.44964,0.53719;
    0.60679,0.53848,0.52992,0.43796,0.60743,0.60327,0.43107,0.50288,0.62193,0.58948;
    0.24291,0.27354,0.17798,0.30548,0.20423,0.39795,0.32511,0.24011,0.27381,0.25191;
    0.30632,0.40607,0.28622,0.28946,0.23771,0.33506,0.37212,0.37299,0.22732,0.29872;
    0.58431,0.59549,0.57606,0.60916,0.52841,0.69657,0.67246,0.57707,0.6039,0.72356;
    % 24
    0.61359,0.61438,0.68968,0.39198,0.62533,0.70372,0.68574,0.63731,0.39193,0.66686;
    0.31097,0.32704,0.19673,0.32916,0.26646,0.34847,0.23722,0.24142,0.24129,0.29471;
    0.33828,0.1754,0.18473,0.2163,0.21335,0.24773,0.29949,0.25138,0.22612,0.19027;
    0.43764,0.4201,0.42466,0.33267,0.28156,0.49259,0.36953,0.40763,0.25807,0.40395;
    0.21428,0.22975,0.22918,0.20526,0.19819,0.2735,0.21797,0.25702,0.28705,0.26955;
    0.40727,0.43325,0.34863,0.49155,0.40164,0.3395,0.4054,0.35603,0.35209,0.41509;
    % 30
    0.24516,0.20179,0.22509,0.26404,0.23739,0.31354,0.40802,0.20069,0.29594,0.16636;
    0.3818,0.45897,0.4074,0.37764,0.3346,0.38663,0.3412,0.40116,0.31228,0.50804;
    0.4108,0.30712,0.32075,0.31362,0.38997,0.29997,0.47325,0.34626,0.32177,0.32174;
    0.29799,0.28041,0.18346,0.23818,0.21474,0.28562,0.28801,0.28683,0.27283,0.25662;
    0.40482,0.29304,0.41218,0.4756,0.23167,0.41282,0.42507,0.29811,0.33472,0.24403;
    0.43822,0.311,0.29706,0.42045,0.32724,0.37068,0.46812,0.37287,0.38103,0.38036;
    % 36
    ];
n = [0.077527,0.049399,0.07731,0.073923,0.12607,0.10425,0.078613,0.070433,0.12413,0.071355;
    0.10462,0.087408,0.11118,0.087405,0.051313,0.097658,0.10847,0.10773,0.096843,0.05547;
    0.074293,0.043806,0.095513,0.040575,0.073919,0.057703,0.014603,0.034845,0.048164,0.016211;
    0.08818,0.11819,0.078371,0.12787,0.08023,0.091859,0.086258,0.094516,0.12072,0.0829;
    0.18925,0.20493,0.29674,0.19325,0.19339,0.18667,0.18991,0.20912,0.23944,0.22875;
    0.11587,0.11642,0.16942,0.16623,0.11021,0.1225,0.10866,0.081146,0.12368,0.068056;
    % 6
    0.069735,0.09112,0.10027,0.045116,0.065275,0.11843,0.077005,0.072629,0.062368,0.10994;
    0.21157,0.15015,0.14406,0.11407,0.18849,0.15693,0.22836,0.19162,0.15502,0.26041;
    0.10976,0.087095,0.085928,0.092913,0.12571,0.13521,0.17877,0.084261,0.097574,0.06533;
    0.13488,0.075691,0.099615,0.17722,0.12174,0.10416,0.13684,0.065825,0.058189,0.10792;
    0.097235,0.12776,0.065112,0.082491,0.15123,0.077427,0.10718,0.1821,0.08698,0.099938;
    0.15767,0.084568,0.10001,0.19745,0.12019,0.12275,0.1549,0.17159,0.11701,0.13268;
    % 12
    0.71862,0.45561,0.49605,0.71731,0.89197,0.81078,0.73704,0.6367,0.49873,0.51499;
    0.1086,0.12274,0.20261,0.072508,0.12079,0.10155,0.1021,0.14372,0.1395,0.1303;
    0.022467,0.04931,0.058177,0.052103,0.044576,0.087992,0.035448,0.035035,0.0331,0.023688;
    0.20855,0.17656,0.30618,0.13911,0.30467,0.33441,0.20364,0.244,0.21212,0.19294;
    0.12084,0.16238,0.13171,0.14871,0.14271,0.12222,0.12774,0.11216,0.10606,0.15072;
    0.15051,0.30714,0.30927,0.18808,0.1937,0.17534,0.23077,0.27493,0.27104,0.38276;
    % 18
    0.12633,0.132,0.14045,0.1361,0.11043,0.17053,0.10243,0.12878,0.10449,0.15982;
    0.070182,0.066361,0.11523,0.086645,0.093873,0.074928,0.060083,0.045352,0.083623,0.12104;
    0.14506,0.14644,0.12416,0.14629,0.14358,0.17809,0.16336,0.1083,0.12583,0.13929;
    0.17442,0.22657,0.15113,0.1706,0.1765,0.20328,0.15644,0.17244,0.1201,0.25887;
    0.22719,0.25461,0.19094,0.18652,0.12034,0.15713,0.22743,0.27233,0.16108,0.21993;
    0.2904,0.24554,0.29254,0.28913,0.26277,0.2642,0.29941,0.35932,0.27717,0.24321;
    % 24
    0.12176,0.10294,0.11675,0.088167,0.097625,0.15303,0.11161,0.080726,0.070244,0.10891;
    0.14721,0.13817,0.17988,0.11561,0.11416,0.23327,0.10203,0.12912,0.12629,0.13923;
    0.16087,0.12404,0.14463,0.13922,0.15184,0.1106,0.19753,0.1672,0.18345,0.13618;
    0.15824,0.10605,0.075579,0.06855,0.087205,0.068206,0.11349,0.10164,0.048751,0.14919;
    0.18625,0.20223,0.23932,0.25637,0.20426,0.21655,0.1942,0.19121,0.31627,0.22154;
    0.11514,0.21137,0.10921,0.20287,0.17927,0.13517,0.23699,0.15946,0.1263,0.21971;
    % 30
    0.092136,0.082519,0.095249,0.095726,0.098273,0.10757,0.055757,0.10727,0.184,0.071351;
    0.081117,0.14782,0.18573,0.10093,0.067187,0.087601,0.09474,0.17887,0.048417,0.092992;
    0.10016,0.066054,0.052285,0.12665,0.16266,0.051922,0.10507,0.074021,0.061712,0.1013;
    0.16145,0.17322,0.14031,0.17273,0.14769,0.18503,0.13164,0.14739,0.13338,0.2443;
    0.063375,0.065266,0.14742,0.093745,0.088075,0.092753,0.082976,0.061742,0.12199,0.087793;
    0.29214,0.26359,0.25256,0.26968,0.17108,0.33326,0.35674,0.18395,0.13771,0.20777;
    % 36
    ];

p = p / 10;
n = n / 10;

ap(1:size(p,1)) = 0;
an(1:size(p,1)) = 0;
for r = 1:size(p,1)
    for c = 1:10
        ap(r) = ap(r) + p(r,c);
        an(r) = an(r) + n(r,c);
    end
end

aap = 0;
aan = 0;
for i = 1:length(ap)
    aap = aap + ap(i);
    aan = aan + an(i);
end
aap = aap / length(ap);
aan = aan / length(an);

p = p * 10;
n = n * 10;

step = 1e-3;
d(1:1e3) = 0;
for turn = 1:1e3
    possi = turn * step;
    for r = 1:size(p,1)
        for c = 1:size(p,2)
            if p(r,c) >= possi
                d(turn) = d(turn) + p(r,c) - possi;
            else
            end
            if n(r,c) >= possi
            else
                d(turn) = d(turn) + n(r,c) - possi;
            end
        end
    end
end
d = d/2/size(p,1)/size(p,2);
d = abs(d);
min = 1;
index = 0;
for each = 1:length(d)
    if d(each) < min
        min = d(each);
        index = each;
    end
end

subplot(1,2,1);
hold on
plot(1:length(ap),ap,'ro-');
plot(1:length(ap),aap,'r*');
plot(1:length(an),an,'bo-');
plot(1:length(an),aan,'b*');
plot(1:length(ap),index/length(d),'x');
title(['aver-p = ',num2str(aap),', aver-n = ',num2str(aan),', by groups']);
hold off

subplot(1,2,2);
hold on
for r = 1:size(p,1)
    for c = 1:size(p,2)
        plot(((r-1)*size(p,1)+c)/size(p,1)/size(p,2)/3.6,p(r,c),'rx');
        plot(((r-1)*size(p,1)+c)/size(p,1)/size(p,2)/3.6,n(r,c),'bx');
        plot(d(:),1e-3:1e-3:1,'go');
        plot(((r-1)*size(p,1)+c)/size(p,1)/size(p,2)/3.6,index/length(d),'o');
    end
end
title(['by each data, possibility = ',num2str(index/length(d))]);
hold off

%% color of plants
clear;

x = 1:256;

r_hist(x) = 0;
g_hist(x) = 0;
b_hist(x) = 0;
for set = 1:21
    I = imread(['./img/plants/',num2str(set),'.png']);
    red(1:size(I,1),1:size(I,2)) = I(:,:,1);
    green(1:size(I,1),1:size(I,2)) = I(:,:,2);
    blue(1:size(I,1),1:size(I,2)) = I(:,:,3);
    for r = 1:size(I,1)
        for c = 1:size(I,2)
            r_hist(red(r,c)+1) = r_hist(red(r,c)+1) + 1;
            g_hist(green(r,c)+1) = g_hist(green(r,c)+1) + 1;
            b_hist(blue(r,c)+1) = b_hist(blue(r,c)+1) + 1;
        end
    end
end
r_hist = r_hist/21;
g_hist = g_hist/21;
b_hist = b_hist/21;

per = 0.15;
for i = 2:256
    if r_hist(i) == max(r_hist)
        r_index = i;
    end
    if (r_hist(i-1)<=per*max(r_hist))&&(r_hist(i)>per*max(r_hist))
        r_min = i;
    end
    if (r_hist(i-1)>per*max(r_hist))&&(r_hist(i)<=per*max(r_hist))
        r_max = i;
    end
    
    if g_hist(i) == max(g_hist)
        g_index = i;
    end
    if (g_hist(i-1)<=per*max(g_hist))&&(g_hist(i)>per*max(g_hist))
        g_min = i;
    end
    if (g_hist(i-1)>per*max(g_hist))&&(g_hist(i)<=per*max(g_hist))
        g_max = i;
    end
    
    if b_hist(i) == max(b_hist)
        b_index = i;
    end
    if (b_hist(i-1)<=per*max(b_hist))&&(b_hist(i)>per*max(b_hist))
        b_min = i;
    end
    if (b_hist(i-1)>per*max(b_hist))&&(b_hist(i)<=per*max(b_hist))
        b_max = i;
    end
end

hold on
axis([0,125,0,2000]);
plot(x,r_hist,'r-',x,g_hist,'g-',x,b_hist,'b-');
stem(r_min,r_hist(r_min),':r');
stem(r_index,r_hist(r_index),':r');
stem(r_max,r_hist(r_max),':r');
stem(g_min,g_hist(g_min),':g');
stem(g_index,g_hist(g_index),':g');
stem(g_max,g_hist(g_max),':g');
stem(b_min,b_hist(b_min),':b');
stem(b_index,b_hist(b_index),':b');
stem(b_max,b_hist(b_max),':b');
hold off

disp('plants');
disp(['r left = ',num2str(r_min),'; r max = ',num2str(r_index),'; r right = ',num2str(r_max)]);
disp(['g left = ',num2str(g_min),'; g max = ',num2str(g_index),'; g right = ',num2str(g_max)]);
disp(['b left = ',num2str(b_min),'; b max = ',num2str(b_index),'; b right = ',num2str(b_max)]);

%% color of soil
clear;

x = 1:256;

r_hist(x) = 0;
g_hist(x) = 0;
b_hist(x) = 0;
for set = 1:21
    I = imread(['./img/soil/',num2str(set),'.png']);
    red(1:size(I,1),1:size(I,2)) = I(:,:,1);
    green(1:size(I,1),1:size(I,2)) = I(:,:,2);
    blue(1:size(I,1),1:size(I,2)) = I(:,:,3);
    for r = 1:size(I,1)
        for c = 1:size(I,2)
            r_hist(red(r,c)+1) = r_hist(red(r,c)+1) + 1;
            g_hist(green(r,c)+1) = g_hist(green(r,c)+1) + 1;
            b_hist(blue(r,c)+1) = b_hist(blue(r,c)+1) + 1;
        end
    end
end
r_hist = r_hist/21;
g_hist = g_hist/21;
b_hist = b_hist/21;

per = 0.15;
for i = 2:256
    if r_hist(i) == max(r_hist)
        r_index = i;
    end
    if (r_hist(i-1)<=per*max(r_hist))&&(r_hist(i)>per*max(r_hist))
        r_min = i;
    end
    if (r_hist(i-1)>per*max(r_hist))&&(r_hist(i)<=per*max(r_hist))
        r_max = i;
    end
    
    if g_hist(i) == max(g_hist)
        g_index = i;
    end
    if (g_hist(i-1)<=per*max(g_hist))&&(g_hist(i)>per*max(g_hist))
        g_min = i;
    end
    if (g_hist(i-1)>per*max(g_hist))&&(g_hist(i)<=per*max(g_hist))
        g_max = i;
    end
    
    if b_hist(i) == max(b_hist)
        b_index = i;
    end
    if (b_hist(i-1)<=per*max(b_hist))&&(b_hist(i)>per*max(b_hist))
        b_min = i;
    end
    if (b_hist(i-1)>per*max(b_hist))&&(b_hist(i)<=per*max(b_hist))
        b_max = i;
    end
end

hold on
axis([50,175,0,2500]);
plot(x,r_hist,'r-',x,g_hist,'g-',x,b_hist,'b-');
stem(r_min,r_hist(r_min),':r');
stem(r_index,r_hist(r_index),':r');
stem(r_max,r_hist(r_max),':r');
stem(g_min,g_hist(g_min),':g');
stem(g_index,g_hist(g_index),':g');
stem(g_max,g_hist(g_max),':g');
stem(b_min,b_hist(b_min),':b');
stem(b_index,b_hist(b_index),':b');
stem(b_max,b_hist(b_max),':b');
hold off

disp('soil');
disp(['r left = ',num2str(r_min),'; r max = ',num2str(r_index),'; r right = ',num2str(r_max)]);
disp(['g left = ',num2str(g_min),'; g max = ',num2str(g_index),'; g right = ',num2str(g_max)]);
disp(['b left = ',num2str(b_min),'; b max = ',num2str(b_index),'; b right = ',num2str(b_max)]);

%%
clear;

I = imread('./img/杭州萧山国际机场.png');

plants = ColorRange('plants');
soil = ColorRange('soil');

for r = 1:size(I,1)
    for c = 1:size(I,2)
        condi_r = I(r,c,1)>=plants(1,1)&&I(r,c,1)<=plants(1,3);
        condi_r = condi_r||I(r,c,1)>=soil(1,1)&&I(r,c,1)<=soil(1,3);
        
        condi_g = I(r,c,2)>=plants(2,1)&&I(r,c,2)<=plants(2,3);
        condi_g = condi_g||I(r,c,2)>=soil(2,1)&&I(r,c,2)<=soil(2,3);
        
        condi_b = I(r,c,3)>=plants(3,1)&&I(r,c,3)<=plants(3,3);
        condi_b = condi_b||I(r,c,3)>=soil(3,1)&&I(r,c,3)<=soil(3,3);
        
        condition = condi_r && condi_g && condi_b;
        if condition
            I(r,c,:) = 255;
        end
    end
end
imshow(I);

%% color
clear;

plants = ColorRange('plants',0.15);
soil = ColorRange('soil',0.03);
road = ColorRange('paved_road',0.1);

count = 0;
height = 121;
width = 121;
%filename = '20170731-侧摆角(17.0626)-美国-西雅图-塔科马国际机场';
%I = imread(['./img/',filename,'.jpg']);
%filename = '杭州萧山国际机场';
%I = imread(['./img/',filename,'.png']);
filename = 'part1';
I = imread(['./img/',filename,'.jpg']);
row_min = (height-1)/2;
col_min = (width-1)/2;
row_max = size(I,1) - row_min;
col_max = size(I,2) - col_min;
for r = row_min:row_max
    for c = col_min:col_max
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
        condition = condition||(I(r,c,1)<200)||(I(r,c,2)<200)||(I(r,c,3)<200);
        
        if condition
            I(r,c,:) = [200,0,0];
            count = count + 1;
        end
    end
end
percent = 100*count/(size(I,1)-height+1)/(size(I,2)-width+1);
disp(['percent = ',num2str(percent),'%']);
imwrite(I(row_min:row_max,col_min:col_max,:),...
    ['./img/test-',num2str(percent),'%-',filename,'.tif']);
disp('done');

%% 
clear;

filename = 'part2';
I = imread(['./img/',filename,'.jpg']);
Gray = rgb2gray(I);
background = imopen(Gray,strel('disk',8));
Gray = imsubtract(Gray,background);
Logi = imbinarize(Gray);
BW = Logical2bw(Logi);

imshow(BW);
time = datetime('now');
saveas(gcf,['./img/result/','result-',filename,'-',...
    num2str(time.Year),'-',num2str(time.Month),'-',num2str(time.Day),'-',...
    num2str(time.Hour),'-',num2str(time.Minute),'-',num2str(time.Second),'.tif']);

%% use well trained nets
clear;

Structure = load('./MaybeWellTrainedNets/neuralNet-1.mat');
disp(Structure.neuralNet);
input(1:14641) = 0;
[output, ~] = Apply(Structure.neuralNet, input);
disp(['output = ',num2str(output)]);

%% expand sample
clear;

img = imread('./img/is_plane/1.tif');
m(1:size(img,1),1:size(img,2)) = 0;
for r = 1:size(img,1)
    for c = 1:size(img,2)
        if r+c == size(img,1)+1
            m(r,c) = 1;
        end
    end
end
for i = 1:64
    img = imread(['./img/is_plane/',num2str(i),'.tif']);
    img = im2double(img);
    i2 = img * m;
    imwrite(i2,['./img/is_plane/',num2str(i+64),'.tif']);
end
disp('done');