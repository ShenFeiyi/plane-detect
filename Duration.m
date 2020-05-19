function Duration(start, finish)
% extensions

    day = finish.Day - start.Day;
    
    hour = finish.Hour - start.Hour;
    if hour < 0
        hour = hour + 24;
        day = day - 1;
    end
    
    minute = finish.Minute - start.Minute;
    if minute < 0
        minute = minute + 60;
        hour = hour - 1;
    end
    
    second = finish.Second - start.Second;
    if second < 0
        second = second + 60;
        minute = minute - 1;
    end
    
    for year = start.Year:finish.Year
        if (year==start.Year)&&(year~=finish.Year)
            month = start.Month+1:12;
        elseif (year~=start.Year)&&(year==finish.Year)
            month = 1:finish.Month;
        elseif (year==start.Year)&&(year==finish.Year)
            month = start.Month:finish.Month-1;
        else
            month = 1:12;
        end
        for m = 1:length(month)
            if (month(m)==1)||(month(m)==3)||(month(m)==5)||...
                    (month(m)==7)||(month(m)==8)||(month(m)==10)||(month(m)==12)
                day = day + 31;
            elseif (month(m)==4)||(month(m)==6)||(month(m)==9)||(month(m)==11)
                day = day + 30;
            else
                if mod(year,4) == 0
                    if mod(year,100) ~= 0
                        day = day + 29;
                    else
                        if mod(year,400) == 0
                            day = day + 29;
                        else
                            day = day + 28;
                        end
                    end
                else
                    day = day + 28;
                end
            end
        end
    end
    
    if day > 365
        disp(['Duration: around ',num2str(floor(day/365)),' year(s) ',...
            num2str(floor((day-365*floor(day/365))/30)),' month(s) ',...
            num2str(day-30*floor((day-365*floor(day/365))/30)-365*floor(day/365)),' day(s) ',...
            num2str(hour),' hour(s) ',...
            num2str(minute),' minute(s) ',...
            num2str(second),' second(s) ']);
    elseif day > 30
        disp(['Duration: around',num2str(floor(day/30)),' month(s) ',...
            num2str(day-30*floor(day/30)),' day(s) ',...
            num2str(hour),' hour(s) ',...
            num2str(minute),' minute(s) ',...
            num2str(second),' second(s) ']);
    elseif day == 0
        if hour == 0
            if minute == 0
                disp(['Duration: ',num2str(second),' second(s)']);
            else
                disp(['Duration: ',num2str(minute),' minute(s) ',...
                    num2str(second),' second(s)']);
            end
        else
            disp(['Duration: ',num2str(hour),' hour(s) ',...
                num2str(minute),' minute(s) ',...
                num2str(second),' second(s)']);
        end
    else
        disp(['Duration: ',num2str(day),' day(s) ',...
            num2str(hour),' hour(s) ',...
            num2str(minute),' minute(s) ',...
            num2str(second),' second(s) ']);
    end
end