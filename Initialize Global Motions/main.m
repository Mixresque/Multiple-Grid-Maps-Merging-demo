%% Get initial global motions for merging
clear;
clc;
close all;
load('Input/PairwiseResults.mat');
RotTranM = ('Output/RotTranM.mat');
rm = ('Output/RelativeMotions.mat');
n = size(RelativeMotions,1);
RotTran = zeros(3,n-1);
iter_MCS = 121;
thr_MCS = 1000;
i = eye(3);

% Sample minimal connected graphs and confirm reliability of relative motions
support_best = 0;
mglobal_best = zeros(1,n);
for i = 1:iter_MCS
    edges = find(~cellfun(@isempty,RelativeMotions));
    sub = sampleSubgraph(RelativeMotions, MSE);
    mglobal = mrelative2mglobal(RelativeMotions, sub);
    support = 10;
    sedge = size(edges,1);
    drift = zeros(sedge,1);
    for j = 1:sedge
        fs = ceil(edges(j)/n);
        fe = edges(j) - fs*n+n;
        drift(j) = norm( RelativeMotions{fe,fs}\(mglobal{fs}/mglobal{fe}) - i, 'fro');
        if (drift(j) < thr_MCS)
            support = support + 1;
        end
    end
    if(support >= support_best)
        mglobal_best = mglobal;
        for j = 1:sedge
            if (drift(j) >= thr_MCS)
                RelativeMotions{j} = [];
                MSE(j) = 0;
            end
        end
    end
end

%% Demo for test set
% for i = 3:n
%     RelativeMotions{1,i} = RelativeMotions{1,i-1}*RelativeMotions{i-1,i};
% end

%% Bad initials
% % Calculate global motions 
% for i = 2:n
%     for k = 2:n
%         if isempty(RelativeMotions{1,i})
%             if ~isempty(RelativeMotions{1,k}) && ~isempty(RelativeMotions{k,i})
%                 RelativeMotions{1,i} = RelativeMotions{1,k}*RelativeMotions{k,i};
%             end
%         end
%     end    
% end

% Save global motions with map 1 as reference frame

% for i = 1:n-1
%     tmp = cell2mat(RelativeMotions(1,i+1));
%     % RotTran(i*3-2) = atan(tmp(2,1)/tmp(1,1))+pi*(sign(tmp(2,1))-abs(sign(tmp(2,1))))/(-2);
%     RotTran(i*3-2) = atan2(tmp(2,1),tmp(1,1));
%     RotTran(i*3-1) = tmp(1,3);
%     RotTran(i*3) = tmp(2,3);
% end
save(RotTranM, 'RotTran');                                                 % Save global motions
save(rm,'RelativeMotions');
