clear;
clc;
close all;

global RelativeMotions MSE mglobal_best mcs_best n reliableRM

%% Get initial global motions for merging
load('Input/4PairwiseResults.mat');
RotTranM = ('Output/RotTranM.mat');
rm = ('Output/gm1.mat');
mm = ('Output/mm.mat');
n = size(RelativeMotions,1);
RotTran = zeros(3,n-1);
mglobal_best = cell(1,n);
mcs_best = zeros(n);


% Original dataset: 
iter_MCS = n*n;
thr_r = 0.02;
thr_t = 16;
support_best = 0;
support_best = sampleAndConfirm(iter_MCS, thr_r, thr_t, support_best);
showSubgraph(mcs_best,reliableRM)
load('Input\tmp.mat')
src = 'data4\Loop25';
img_out = 'Output\22coarse.png';
% test3
M0=mglobal_best;

load('Input/4PairwiseResults.mat');
reliableRM = ~cellfun(@isempty,RelativeMotions);

%% Perform motion average algorithm
[mglobal_best, xxx, yyy] = motionAverage(mglobal_best, reliableRM, RelativeMotions);
img_out = 'Output\22fine.png';
test3
M10=mglobal_best;
save(mm,'M0','M10');

% % Save global motions with map 1 as reference frame
% for i = 1:n-1
%     tmp = mglobal_best{i+1};
%     % RotTran(i*3-2) = atan(tmp(2,1)/tmp(1,1))+pi*(sign(tmp(2,1))-abs(sign(tmp(2,1))))/(-2);
%     RotTran(i*3-2) = atan2(tmp(2,1),tmp(1,1));
%     RotTran(i*3-1) = tmp(1,3);
%     RotTran(i*3) = tmp(2,3);
% end
% save(RotTranM, 'RotTran');                                                 % Save global motions
% save(rm,'mglobal_best');
