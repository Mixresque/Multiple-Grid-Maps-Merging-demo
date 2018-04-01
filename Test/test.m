%% Use global rotation angles and transformation vectors
clear
n=11;
load('RotTranM.mat');
im1 = imread('datax\Fr1.png');
MergeMap= rgb2gray(im1);
t0 = [0;0];
t_offset = [0;0];
for i = 2:n
    tmp = RotTran(1:3,i-1);
    R = [cos(tmp(1)),-sin(tmp(1));sin(tmp(1)),cos(tmp(1))];
    t = tmp(2:3);
    im2 = imread(join(['datax\Fr',num2str(i),'.png'])); 
    Dmap= rgb2gray(im2);
    t0 = t0 + t_offset([2 1],:);
    t = t + t0;
    [MergeMap,t_offset] = merging(MergeMap,Dmap,R,t); 
end
figure('Name','global rotation angles and transformation vectors');
imshow(MergeMap)
