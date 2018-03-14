function [R, t] = FastTrICP( Model, Data, R, t, id, MoveStep)
global TrMax TrMin KDtree

PreMSE= 10^5;   CurMSE= 10^6;  step = 1;
TData = transform_to_global(Data, R, t);
while(step < MoveStep)&(abs(CurMSE-PreMSE)>10^(-6))
    [corr,TD] = knnsearch(KDtree{id,1},TData');
    SortTD2 = sortrows(TD.^2); % Sort the correspongding points
    minTDIndex = floor(TrMin*length(TD)); % Get minimum index of TD
    maxTDIndex = ceil(TrMax*length(TD)); % Get maxmum index of TD
    TDIndex = [minTDIndex : maxTDIndex]';
    mTr = TDIndex./length(TD);
    mCumTD2 = cumsum(SortTD2); % Get accumulative sum of sorted TD.^2
    mMSE = mCumTD2(minTDIndex : maxTDIndex)./TDIndex; % Compute all MSE
    mPhi = ObjectiveFunction(mMSE, mTr);  
    PreMSE=CurMSE;
    [CurMSE, nIndex] = min(mPhi);    
    Trim = mTr(nIndex); % Update Tr for next step    
    corr(:,2) = [1 : length(corr)]';
    % Sort the corresponding points
    corrTD = [corr, TD];
    SortCorrTD = sortrows(corrTD, 3);
    [R, t, TCorr, TData] = CalRtPhi(Model, Data, SortCorrTD, Trim);
    step= step+1;
end

%%%%%%%%%%%%%%%%%%%%Integrated Function%%%%%%%%%%%%%%%%%%%%
%% Calculate R,t,Phi based on current overlap parameter
function [R, t,TCorr,TData] = CalRtPhi(Model, Data, SortCorrTD,Tr)

TrLength = floor(Tr*size(SortCorrTD,1)); % The number of corresponding points after trimming
TCorr = SortCorrTD(1:TrLength, 1:2);     % Trim the corresponding points according to overlap parameter Tr
% Register MData with TData
[R, t] = reg(Model, Data, TCorr);
% To obtain the transformation data
TData = transform_to_global(Data, R, t);


%%%%%%%%%%%%%%% Calculate the registration matrix %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% T(TData)->MData %%%%%%%%%%%%%%%%%%%%%%%%%
% SVD solution
function [R1, t1] = reg(Model, Data, corr)

n = length(corr); 
M = Model(:,corr(:,1)); 
mm = mean(M,2);
S = Data(:,corr(:,2));
ms = mean(S,2); 
Sshifted = [S(1,:)-ms(1); S(2,:)-ms(2)];
Mshifted = [M(1,:)-mm(1); M(2,:)-mm(2)];
K = Sshifted*Mshifted';
K = K/n;
[U A V] = svd(K);
R1 = V*U';
if det(R1)<0
    B = eye(2);
    B(2,2) = det(V*U');
    R1 = V*B*U';
end
t1 = mm - R1*ms;
