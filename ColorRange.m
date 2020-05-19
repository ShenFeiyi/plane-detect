function Color = ColorRange(things,per,show)
% return a color range matrix of different things
% 3x3 matrix
% [r_left, r_max, r_right;
%  g_left, g_max, g_right;
%  b_left, b_max, b_right]

    Color(1:3,1:3) = nan;

    if nargin == 0
        things = '';
    elseif nargin == 1
        per = 0.1;
        show = false;
    elseif nargin == 2
        show = false;
    end
    
    if strcmp(things,'plants')||strcmp(things,'soil')||strcmp(things,'paved_road')
        r_hist(1:256) = 0;
        g_hist(1:256) = 0;
        b_hist(1:256) = 0;
        for set = 1:21
            I = imread(['./img/',things,'/',num2str(set),'.png']);
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

        for i = 2:256
            if (r_hist(i-1)<=per*max(r_hist))&&(r_hist(i)>per*max(r_hist))
                r_min = i;
                break;
            end
        end
        for i = 2:256
            if (g_hist(i-1)<=per*max(g_hist))&&(g_hist(i)>per*max(g_hist))
                g_min = i;
                break;
            end
        end
        for i = 2:256
            if (b_hist(i-1)<=per*max(b_hist))&&(b_hist(i)>per*max(b_hist))
                b_min = i;
                break;
            end
        end
        
        for i = 2:256
            if r_hist(i) == max(r_hist)
                r_index = i;
            end
            if (r_hist(i-1)>per*max(r_hist))&&(r_hist(i)<=per*max(r_hist))
                r_max = i;
            end

            if g_hist(i) == max(g_hist)
                g_index = i;
            end
            if (g_hist(i-1)>per*max(g_hist))&&(g_hist(i)<=per*max(g_hist))
                g_max = i;
            end

            if b_hist(i) == max(b_hist)
                b_index = i;
            end
            if (b_hist(i-1)>per*max(b_hist))&&(b_hist(i)<=per*max(b_hist))
                b_max = i;
            end
        end

        if show
            ymax = max(max(max(r_hist),max(g_hist)),max(b_hist));
            for i = 2:256
                if (r_hist(i-1)<=1)&&(r_hist(i)>1)
                    xrmin = i-1;
                    break;
                end
            end
            for i = 2:256
                if (g_hist(i-1)<=1)&&(g_hist(i)>1)
                    xgmin = i-1;
                    break;
                end
            end
            for i = 2:256
                if (b_hist(i-1)<=1)&&(b_hist(i)>1)
                    xbmin = i-1;
                    break;
                end
            end
            xmin = min(min(xrmin,xgmin),xbmin);
            for i = 2:256
                if (r_hist(i-1)>1)&&(r_hist(i)<=1)
                    xrmax = i;
                end
                if (g_hist(i-1)>1)&&(g_hist(i)<=1)
                    xgmax = i;
                end
                if (b_hist(i-1)>1)&&(b_hist(i)<=1)
                    xbmax = i;
                end
            end
            xmax = max(max(xrmax,xgmax),xbmax);
            hold on
            
            disp(['xmin = ',num2str(xmin),...
                '; xmax = ',num2str(xmax),...
                '; ymax = ',num2str(ymax)]);
            
            axis([xmin,xmax,0,ymax]);
            plot(1:256,r_hist,'r-',1:256,g_hist,'g-',1:256,b_hist,'b-');
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

            disp(things);
            disp(['r left = ',num2str(r_min),'; r max = ',num2str(r_index),...
                '; r right = ',num2str(r_max)]);
            disp(['g left = ',num2str(g_min),'; g max = ',num2str(g_index),...
                '; g right = ',num2str(g_max)]);
            disp(['b left = ',num2str(b_min),'; b max = ',num2str(b_index),...
                '; b right = ',num2str(b_max)]);
        end
        Color = [r_min,r_index,r_max;g_min,g_index,g_max;b_min,b_index,b_max];
    else
        disp([things,' not in dataset yet...']);
        disp('Please wait for update.')
    end
end