function [inlineNum,TrRAM] = RANSAC(PMforR, restEdge, RMSTAM)

global MijAllE dRmax dtmax

[count,~] = size(restEdge);
TrRAM = RMSTAM;
inlineNum = 0;
for k=1:count
    i = restEdge(k,1);
    j = restEdge(k,2);
    [R,t] = M2Rt(MijAllE(i,j).M);
    [R0,t0] = M2Rt(PMforR(i).M\PMforR(j).M);   % inv(PMforR(i).M)*PMforR(j).M
    dR = sum(sum(abs(R-R0)));
    dt = sum((t-t0).^2);
    if((dR<dRmax) && (dt<dtmax))
        inlineNum = inlineNum + 1;
        TrRAM(i,j) = 1;
        TrRAM(j,i) = 1;
    end
    
    j = restEdge(k,1);
    i = restEdge(k,2);
    [R,t] = M2Rt(MijAllE(j,i).M);
    [R0,t0] = M2Rt(PMforR(j).M\PMforR(i).M);   % inv(PMforR(j).M)*PMforR(i).M
    dR = sum(sum(abs(R-R0)));
    dt = sum((t-t0).^2);
    if((dR<dRmax) && (dt<dtmax))
        inlineNum = inlineNum + 1;
        TrRAM(i,j) = 1;
        TrRAM(j,i) = 1;
    end
end