function TrM= computer_trim(shape,pM,res,dist)

global N RotTran TrMin TrMax KDtree

TrM= zeros(N,N);

for i=1:N
    scani= shape{i,1}'*1000;
    Model= scani(:,1:res:end);
    TD= []; nums= [];
    for j=1:N
        if(i~=j)
            Mij= inv(pM(i).M)*pM(j).M;
            [R,t]= M2Rt(Mij);
            scanj= shape{j,1}'*1000;
            Data= scanj(:,1:res:end);
            TData = transform_to_global(Data, R, t);
            [corr,TDi] = knnsearch(KDtree{i,1}, TData');
            TD= [TD;TDi];
            nums= [nums,length(TDi)];
        end
    end
    SortTD2 = sortrows(TD.^2); % Sort the correspongding points
    minTDIndex = floor(TrMin*length(TD)); % Get minimum index of TD
    maxTDIndex = ceil(TrMax*length(TD)); % Get maxmum index of TD
    TDIndex = [minTDIndex : maxTDIndex]';
    mTr = TDIndex./length(TD);
    mCumTD2 = cumsum(SortTD2); % Get accumulative sum of sorted TD.^2
    mMSE = mCumTD2(minTDIndex : maxTDIndex)./TDIndex; % Compute all MSE
    mPhi = ObjectiveFunction(mMSE, mTr);
    [minPhi, nIndex] = min(mPhi);
    Trim = mTr(nIndex); % Update Tr for next step
    dist= sqrt(SortTD2(ceil(length(TD)*Trim)));
    ii= 0;  no= 0;
    for j= 1:N
        if(i==j)
            TrM(i,j)= 1;
        else
            ii= ii+1;
            ni= nums(ii);
            TDi= TD(no+1:no+ni);
            no= no+ni;
            [id,val]= find(TDi<=dist);
            TrM(i,j)= length(id)/length(TDi);
        end
    end
end


