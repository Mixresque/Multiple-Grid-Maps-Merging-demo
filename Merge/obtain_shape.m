function obtain_shape(dataN,pM)

global MShape N res  KDtree

MShape= [];
for i=1:N
  [R0,t0]= M2Rt(pM(i).M);
  Scan= dataN{i,1}'*1000;
  Data= Scan(:,1:res:end);
  KDtree{i,1}=  createns(Data'); 
  TData = transform_to_global(Scan, R0, t0);
  plot(TData(1,:),TData(2,:),'.b');
  MShape=[MShape,TData];
  hold on
end