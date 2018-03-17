clear
close all
%% Use global rotation angles and transformation vectors
n=3
load('RotTranM.mat');
im1 = imread('data\Fr1.png');
MergeMap= rgb2gray(im1);
%     tmp = RotTran(1:3,2);
%     R = [cos(tmp(1)),-sin(tmp(1));sin(tmp(1)),cos(tmp(1))];
%     t = tmp(2:3);
%     im2 = imread(join(['data\Fr',num2str(3),'.png'])); 
%     Dmap= rgb2gray(im2);
%     MergeMap = merging(MergeMap,Dmap,R,t);

for i = 2:n
    tmp = RotTran(1:3,i-1);
    R = [cos(tmp(1)),-sin(tmp(1));sin(tmp(1)),cos(tmp(1))];
    t = tmp(2:3);
    im2 = imread(join(['data\Fr',num2str(i),'.png'])); 
    Dmap= rgb2gray(im2);
    MergeMap = merging(MergeMap,Dmap,R,t); 
end
figure('Name','global rotation angles and transformation vectors');
imshow(MergeMap)
