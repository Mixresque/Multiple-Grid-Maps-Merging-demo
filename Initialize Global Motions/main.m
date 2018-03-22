%% Get initial global motions for merging
clear;
clc;
close all;

global RelativeMotions MSE mglobal_best mcs_best n

load('Input/PairwiseResults.mat');
RotTranM = ('Output/RotTranM.mat');
rm = ('Output/RelativeMotions.mat');
n = size(RelativeMotions,1);
RotTran = zeros(3,n-1);
iter_MCS = n*n;
thr_MCS = 200;
support_best = 4;

sampleAndConfirm(iter_MCS, thr_MCS, support_best);

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
