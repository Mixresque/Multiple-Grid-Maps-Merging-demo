%% Use global motions
clear;
n=11;
load('RelativeMotions.mat');
im1 = imread('data\Fr1.png');
MergeMap= rgb2gray(im1);
t0 = [0;0];
t_offset = [0;0];
for i = 2:n
    m = cell2mat(RelativeMotions(1,i));
    R = [m(1,1),m(1,2);m(2,1),m(2,2)];
    t = [m(1,3);m(2,3)];
    im2 = imread(join(['data\Fr',num2str(i),'.png'])); 
    Dmap= rgb2gray(im2);
    t0 = t0 + t_offset([2 1],:);
    t = t + t0;
    [MergeMap,t_offset] = merging(MergeMap,Dmap,R,t); 
end
figure('Name','global motions');
imshow(MergeMap)