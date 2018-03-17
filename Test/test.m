%% Use global rotation angles and transformation vectors

load('RotTranM.mat');
im1 = imread('data\Fr1.png');
MergeMap= rgb2gray(im1);


for i = 2:11
    tmp = RotTran(1:3,i-1);
    R = [cos(tmp(1)),-sin(tmp(1));sin(tmp(1)),cos(tmp(1))];
    t = tmp(2:3);
    im2 = imread(join(['data\Fr',num2str(i),'.png'])); 
    Dmap= rgb2gray(im2);
    MergeMap = merging(MergeMap,Dmap,R,t); 
end
figure('Name','global rotation angles and transformation vectors');
imshow(MergeMap)
