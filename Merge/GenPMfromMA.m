function PMforR = GenPMfromMA(RMSTtable,pM)

global N MijAllE

D1 = [];
m = eye(3);
for k=1:N-1
   i = RMSTtable(k,1);
   j = RMSTtable(k,2);
   m = MijAllE{i,j};
   pdM1(k).M= m;
   pdM1(k).i= i;
   pdM1(k).j= j;
   Dij= gen_Dij(i,j,N);
   D1= [D1;Dij];
end
PMforR = Motion_Average(pdM1,pM,D1,N-1);