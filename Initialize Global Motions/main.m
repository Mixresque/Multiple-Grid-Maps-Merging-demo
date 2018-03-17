%% Get initial global motions for merging

load('Input/PairwiseResults.mat');
RotTranM = ('Output/RotTranM.mat');
rm = ('Output/RelativeMotions.mat');
n = size(RelativeMotions,1);
RotTran = zeros(3,n-1);

%% Demo for test set
for i = 3:n
    RelativeMotions(1,i) = mat2cell(cell2mat(RelativeMotions(1,i-1))*cell2mat(RelativeMotions(i-1,i)),3,3);
end

%% Bad initials
% % Calculate global motions 
% for i = 2:n
%     for k = 2:n
%         if isempty(cell2mat(RelativeMotions(1,i)))
%             if ~isempty(cell2mat(RelativeMotions(1,k))) && ~isempty(cell2mat(RelativeMotions(k,i)))
%                 RelativeMotions(1,i) = mat2cell(cell2mat(RelativeMotions(1,k))*cell2mat(RelativeMotions(k,i)),3,3);
%             end
%         end
%     end    
% end

% Save global motions with map 1 as reference frame
for i = 1:n-1
    tmp = cell2mat(RelativeMotions(1,i+1));
    % RotTran(i*3-2) = atan(tmp(2,1)/tmp(1,1))+pi*(sign(tmp(2,1))-abs(sign(tmp(2,1))))/(-2);
    RotTran(i*3-2) = atan2(tmp(2,1),tmp(1,1));
    RotTran(i*3-1) = tmp(1,3);
    RotTran(i*3) = tmp(2,3);
end
save(RotTranM, 'RotTran');                                                 % Save global motions
save(rm,'RelativeMotions');
