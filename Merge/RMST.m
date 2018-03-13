function [RMSTAM,RMSTtable] = RMST(LookTable)

global N

RM = eye(N,N);   % Reachability Matrix
[count, ~] = size(LookTable);   % count used for generating random 
while ~isequal(RM,ones(N,N))    % check randomly generated "MST" is a real MST
    RMSTAM = eye(N,N);
    randij = randperm(count,N-1);   % generate N-1 unique number randomly from 1~count
    for i=1:N-1     % create randomly generated "MST"(have not verified)
        RMSTAM(LookTable(randij(i),1),LookTable(randij(i),2)) = 1;
    end
    RMSTAM = RMSTAM + RMSTAM' - eye(N);
    RM = RMSTAM;
    temp = RMSTAM;
    for i=2:N   % compute Reachability Matrix
        temp = temp*RMSTAM;
        RM = RM + temp;
        RM(RM~=0)=1;
    end
end
randij = sort(randij);
RMSTtable = LookTable(randij,:);