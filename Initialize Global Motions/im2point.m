function  ImPoint= im2point(ImData); 

MDataSource = edge(ImData,'sobel');
[X, Y] = find(MDataSource==1);
Model = [X Y];
mid= Model(:,1);
Model(:,1)= Model(:,2);
Model(:,2)= mid;
ImPoint= Model;

