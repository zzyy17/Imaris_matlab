clc;
clear;
cd('C:/xu/'); % *set up your workspace, where you can put this script,saved images and results sheets.*

% for one directory files, the original files are vsi type, the result files are jpg type.*
nameList = dir('*.vsi'); % for all vsi image files
for i = 1 : length(nameList)
    % 1. turn colorful image to gray image *for one single image file*
    img_tmp = imread(nameList(i).name);
    img_gray = rgb2gray(img_tmp);
    
    % 2. turn in uint8 type
    im = uint8(img_gray);
    
    % 3. generate hotmap graph
    smap = imresize(im, [215, 512]);
    set (gcf,'Position',[0,0,512,215]); 
    imshow(smap,'border','tight','initialmagnification','fit');
    colormap(jet); 
    F=getframe(gcf);
    
    % 4.generate graphs and save it
    hFig1 = subplot(1, 3, 1);
    set(hFig1, 'Position', [0 0 0.32 1]);
    imshow(img_tmp);title('Origin Graph');

    hFig2 = subplot(1, 3, 2);
    set(hFig2, 'Position', [0.33 0 0.32 1]);
    imshow(im);title('Gray Graph');

    hFig3 = subplot(1, 3, 3);
    set(hFig3, 'Position', [0.66 0 0.32 1]);
    imshow(F.cdata);title('Hot Graph');
    
    filename = nameList(i).name;
    cdPath = cd;
    mkdir('result');
    savePath = [cdPath, '\', 'result', '\', filename(1:end-4)];
    
    print(gcf, '-djpeg', savePath);
    close(gcf);
end

%{
 1. turn colorful image to gray image *for one single image file*
img1 = imread('C:\xu\image TEST\image TEST\image_04.vsi'); % *input the image you wanna process.*
img1_new = rgb2gray(img1);
imwrite(img1_new, 'img1_new.jpg');

% 2. turn in uint8 type
im = uint8(img1_new);
imwrite(im, 'img2_new.jpg');

% 3. generate hotmap graph
smap = imresize(im, [215, 512]);
set (gcf,'Position',[0,0,512,215]); 
imshow(smap,'border','tight','initialmagnification','fit');
colormap(jet); 
F=getframe(gcf);

% 4.generate graphs and save it
hFig1 = subplot(1, 3, 1);
set(hFig1, 'Position', [0 0 0.32 1]);
imshow(img1);title('Origin Graph');

hFig2 = subplot(1, 3, 2);
set(hFig2, 'Position', [0.33 0 0.32 1]);
imshow(im);title('Gray Graph');

hFig3 = subplot(1, 3, 3);
set(hFig3, 'Position', [0.66 0 0.32 1]);
imshow(F.cdata);title('Hot Graph');

print(gcf, '-djpeg', 'result');
%}
