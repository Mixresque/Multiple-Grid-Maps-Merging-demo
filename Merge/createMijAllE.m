function createMijAllE(shape,LookTable,TrM,pM,MoveStep,Trim)

global N MijAllE res

[countE, ~] = size(LookTable);   % count edge

for k=1:N
   MijAllE(k,k).M = eye(4);
end
for k=1:countE  % create 
   i = LookTable(k,1);
   j = LookTable(k,2);
   if(TrM(i,j)>Trim)
       Mij= pM(i).M\pM(j).M;   %inv(pM(i).M)*pM(j).M;
       [R0,t0]= M2Rt(Mij);
       Model = shape{i,1}'*1000;
       Data = shape{j,1}'*1000;
       [R, t] = FastTrICP(Model(:,1:res:end), Data(:,1:res:end), R0, t0, i, MoveStep);
       MijAllE(i,j).M = Rt2M(R,t);
       if(TrM(j,i)>Trim)
           Mji= pM(j).M\pM(i).M;   %inv(pM(j).M)*pM(i).M;
           [R0,t0]= M2Rt(Mji);
           Model = shape{j,1}'*1000;
           Data = shape{i,1}'*1000;
           [R, t] = FastTrICP(Model(:,1:res:end), Data(:,1:res:end), R0, t0, j, MoveStep);
           MijAllE(j,i).M = Rt2M(R,t);
       else
           MijAllE(j,i).M = inv(MijAllE(i,j).M);
       end
   else
       Mji= pM(j).M\pM(i).M;   %inv(pM(j).M)*pM(i).M;
       [R0,t0]= M2Rt(Mji);
       Model = shape{j,1}'*1000;
       Data = shape{i,1}'*1000;
       [R, t] = FastTrICP(Model(:,1:res:end), Data(:,1:res:end), R0, t0, j, MoveStep);
       MijAllE(j,i).M = Rt2M(R,t);
       MijAllE(i,j).M = inv(MijAllE(j,i).M);
   end
end