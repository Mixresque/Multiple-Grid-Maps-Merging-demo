TrMin= 0.2;%the min percetage of overlapping
TrMax= 1.0;%the max percetafe of overlapping
N = 11;%grid map counts
%the path of the grid maps
spath = 'data\Fr';%the first grid map is replaced by the fourth in the Fd dataset
load('Output\mm.mat');
[imdata,impoint] = loadMapData(spath,N); %load the image data and cloud point of all the grid maps

for i=1:N
  tmp=M0{i};
  M(i).R=tmp(1:2,1:2);
  M(i).t=tmp(1:2,3);
end
ObjV1= com_objv(M, impoint)/N

for i=1:N
  tmp=M10{i};
  M1(i).R=tmp(1:2,1:2);
  M1(i).t=tmp(1:2,3);
end
ObjV2= com_objv(M1, impoint)/N