function [R, t, MSE]= TrICP(MSource,DSource,R0,t0)

global Model Data

% Transform the Image into point sets
MDataSource = edge(MSource,'sobel');
[X, Y] = find(MDataSource==1);
Model = [X Y];
DDataSource = edge(DSource,'sobel');
[X, Y] = find(DDataSource==1);
Data = [X Y];
mid= Model(:,1);
Model(:,1)= Model(:,2);
Model(:,2)= mid;
mid1= Data(:,1);
Data(:,1)= Data(:,2);
Data(:,2)= mid1;
Data= Data';
Model= Model';

% The TrICP algorithm
[R, t, KSI, MSE] = FastTrICP(R0, t0,100);


