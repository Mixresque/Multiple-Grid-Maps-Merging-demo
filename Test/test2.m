%% Use relative motions i to i-1
clear;
n=3;
load('RelativeMotions.mat');
im1 = imread(join(['data\Fr',num2str(n),'.png'])); 
MergeMap= rgb2gray(im1);

for k = 1:n-1
    i = n-k;     % i = n-1 ~ 1
    m = cell2mat(RelativeMotions(i,i+1));
    R = [m(1,1),m(1,2);m(2,1),m(2,2)];
    t = [m(1,3);m(2,3)];
    im2 = imread(join(['data\Fr',num2str(i),'.png'])); 
    Dmap= rgb2gray(im2);
    MergeMap = merging(Dmap,MergeMap,R,t); 
end
figure('Name','relative motions i to i-1');
imshow(MergeMap)
