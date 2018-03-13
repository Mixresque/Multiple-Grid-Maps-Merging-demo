function  ObjV= com_objv(pM,shape,res)
global  N 

Model= [];
Pnum= [];
for i=1:N
  [R0,t0]= M2Rt(pM(i).M);
  scan= shape{i,1}'*1000;
  TData = transform_to_global(scan(:,1:res:end), R0, t0);
  num= size(TData,2);
  Pnum= [Pnum,num];
  Model=[Model,TData];
end

ObjV= 0;
for i=1:N
    if (i==1)
        id1= 1;
        id2= Pnum(1);
    else
        [id1,id2]= gen_ID(Pnum,i);
    end
    Data=  Model(:,id1:id2);
    Model(:,id1:id2)= [];
    objvi= obj_i(Model,Data);
    ObjV= ObjV+ objvi;
    Model= assemble(id1,Model, Data);
end
 

function  minPhi= obj_i(Model,TData)
global TrMin TrMax
%loadlibrary('nearest_neighbour.dll', 'nearest_neighbour.h');
NS = createns(Model');
[corr, TD] = knnsearch(NS, TData');
%[corr, TD]= nearest_neighbour(Model, TData, +inf);
SortTD2 = sortrows(TD.^2); % Sort the correspongding points
minTDIndex = floor(TrMin*length(TD)); % Get minimum index of TD
maxTDIndex = ceil(TrMax*length(TD)); % Get maxmum index of TD
TDIndex = [minTDIndex : maxTDIndex]';
mTr = TDIndex./length(TD);
mCumTD2 = cumsum(SortTD2); % Get accumulative sum of sorted TD.^2
mMSE = mCumTD2(minTDIndex : maxTDIndex)./TDIndex; % Compute all MSE
mPhi = ObjectiveFunction(mMSE, mTr);
[minPhi, nIndex] = min(mPhi);