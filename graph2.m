clc;
clear; % clear workspace
cd('C:\xyq\Imaris\test'); % *set up your workspace, where you can put this script,saved images and results sheets.*
load mycmp;
% for one directory files, the original files are vsi type, the result files are jpg type.*
nameList = dir('*.vsi'); % for all vsi image files
for i = 1 : length(nameList)
    s=imread(nameList(i).name);
    h = fspecial('average', 12);
    a = imfilter(s,h);
    [h, w, c] = size(a);
    % ture colorful picture to gray picture
    if (c == 3)
        a = rgb2gray(a);
    end     
    figure
    imshow(a);
    % create colorbar
    colorbar('YTickLabel',{'0','0.2','0.4','0.6','0.8','1.0'});
    colormap(mycmp);
end

%{
mycolormap = colormap;% save current colormap to local
save mycolormap mycolormap % save

load mycolormap;
figure£»
imagesc(img);
colormap(mycolormap)
%}
