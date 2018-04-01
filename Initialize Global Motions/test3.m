%% Use global motions

src = 'data2';
im1 = imread(join([src,'\In1.png']));
MergeMap= rgb2gray(im1);
n = size(mglobal_best, 2);
t0 = [0;0];
t_offset = [0;0];
for i = 2:n
    m = mglobal_best{i};
    R = [m(1,1),m(1,2);m(2,1),m(2,2)];
    t = [m(1,3);m(2,3)];
    im2 = imread(join([src,'\In',num2str(i),'.png'])); 
    Dmap= rgb2gray(im2);
    t0 = t0 + t_offset([2 1],:);
    t = t + t0;
    [MergeMap,t_offset] = merging(MergeMap,Dmap,R,t); 
end
% figure('Name','global motions');
figure;
imshow(MergeMap)
