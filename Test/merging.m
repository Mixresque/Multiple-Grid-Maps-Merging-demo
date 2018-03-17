function MergingMap= merging(MSource,DSource,R0,t0)
global Data

% figure
TData= transform_to_global(Data, R0, t0);
[rm,cm]= size(MSource);
[row1,col1]= size(DSource);
cmin= min(TData(1,:));      cmax= max(TData(1,:));
rmin= min(TData(2,:));      rmax= max(TData(2,:));
Ds= [rmin rmin rmax rmax; cmin cmax cmin cmax];
Ms= [1 rm 1 rm;1 1 cm cm];
NMs= [Ms,Ds];
rMin= ceil(min(NMs(1,:)));  rMax= ceil(max(NMs(1,:)));
cMin= ceil(min(NMs(2,:)));  cMax= ceil(max(NMs(2,:)));
rN= (rMax-rMin)+2;          cN= (cMax-cMin)+2;
MSource1(1:rN,1:cN)= MSource(1,1);
MSource1((abs(rMin)+1):(abs(rMin)+rm),(abs(cMin)+1):(abs(cMin)+cm))= MSource;
MSource= [];    MSource= MSource1;
R= inv(R0);
for i= 1:1:rN
    for j= 1:1:cN
        i2= i-abs(rMin);
        j2= j-abs(cMin);
        B= R*([j2;i2]-t0);
        j1= round(B(1));
        i1= round(B(2));
        if (i1<=row1)&(i1>0)&(j1<=col1)&(j1>0)
            MergingMap(i,j)=  min(MSource(i,j),DSource(i1,j1));
        else
            MergingMap(i,j)= MSource(i,j);
        end
    end
end
% imshow(MergingMap)
