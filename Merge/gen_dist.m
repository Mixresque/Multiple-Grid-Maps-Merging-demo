function dist= gen_dist(shape,res)


scan= shape{1,1}'*1000;
Model= scan(:,1:res:end);
[corr, TD] = annsearch(Model, Model, 2);
TD2= TD(2,:);
TD2= sort(TD2);
id= ceil(length(TD2)*0.5);
dist= TD2(id)*5;