clc;
clear; % clear workspace
cd('C:\xyq\excel_pro'); % *set up your workspace, where you can put this script,saved images and results sheets.*

% for one directory files, the original files are vsi type, the result files are jpg type.*
nameList = dir('*.xlsx'); % for all vsi image files
% two values represent range of x axis
x_high = 30;

for i = 1 : length(nameList)
    disp(nameList(i).name);
    [NUM, TXT, RAW] = xlsread(nameList(i).name);
    [m, n] = size(RAW);
    
    filename = nameList(i).name;
    cdPath = cd;
    warning('off', 'all');
    dir_name = filename(1:end-5);
    mkdir(dir_name);
    savePath = [cdPath, '\', dir_name, '\', filename(1:end-5)];
    
    for j = 3 : n
       if isnan(RAW{1, j})
           break;
       end
       X = RAW(:, 1);
       Y = RAW(:, j);
       y1 = Y(2:length(Y),:);
       x1 = X(2:length(Y),:);
       for t = 1:length(y1)
           if isnan(y1{t})
               x1{t} = NaN;
           end
       end
       % disp(y1);
       % disp(x1);
       y1(find(all(cellfun(@(t) isnan(t),y1),2)),:)=[];
       x1(find(all(cellfun(@(t) isnan(t),x1),2)),:)=[];
       y = cell2mat(y1);
       x = cell2mat(x1);
       %plot scatter
       num = 0;
       for k = 1 : length(x)
           if x(k) > x_high
               break;
           end
           num = num + 1;
       end
        
       yy = y(1:num);
       xx = x(1:num);
       % figure;
       % scatter(xx, yy, 30,'filled', 'r');
       [P,S] = polyfit(xx, yy, 1);
       yfit = P(1)*xx + P(2);
       R2 = norm(yfit -mean(yy))^2/norm(yy - mean(yy))^2;
       
       %disp(t_R2);
       % p = polyfit(x,y,1);
       xt = linspace(min(xx), max(xx));
       yt = polyval(P, xt);
       fig = figure;
       plot(x, y, 'r*', xt, yt, 'k--');
       %hold on;
       %e = std(t_y)*ones(size(t_x));
       %errorbar(t_x, t_y, e);
       %hold off;
       title(RAW(1,j));
       xlabel('time/h');ylabel('brdu density/100*number/um2');
       str1 = sprintf('%s%f%s%f$', '$y=', P(1), '*x+',P(2));
       str2 = sprintf('%s%f', '$$R^{2}=$$', R2);
       val = max(y)/2;
       text(15, val + 0.1, {str1, ...
           str2}, 'interpreter',  'latex');
       saveName = strcat(savePath, RAW{1,j});
       print(fig, saveName, '-dpng');
       close;
    end
end
