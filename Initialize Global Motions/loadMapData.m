function [imdata,impoint] = loadMapData(spath,N)
%load the image data and cloud point of all the grid maps

for i = 1:N
    path = strcat(spath, num2str(i) ,'.png');
    im = imread(path);
    imdata{i} = rgb2gray(im);
    impoint{i,1}= im2point(imdata{i}); %get the cloud point of all the grid maps
end

