% cannot load nearest_neighbour.dll.

clc
clear
close all
global RotTran N MShape TrMin TrMax KDtree res

%%%%%% used for RANSAC %%%%%%
global dRmax dtmax MijAllE MijAllETmp ReachedV
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TrMin= 0.5;
TrMax= 1.0;
load Maps;
load RotTranM;
shape= map;
%RotTran= RotTran;      % 6*9 matrix, first 3 rows is R(Ouler), second 3 rorows is T.
                        % because we have 10 samples, so as one sample is
                        % reference, we need 9 matrix to transform.
RotTran(1:3,:)=RotTran(1:3,:)+0.02;     % bunny plus noise?
res= 8;                 % step length?
MoveStep= 30;           % how many ICP show loop?
Trim= 0.35;              %?1
[N,M]=size(shape);      % N:the num of sample. M:? debug shows the value is 2?

pM= initialise_M(N);    % initialise M from RotTran
TrMin= 0.3;             %?2
figure                  % create window
obtain_shape(shape,pM);
% plane(1,-20.1,-19.8)    % show a section of bunny
% plane(2,99.8,100.2)    %dragon

iter= 0;    err= 10;
ERROR= (N-1)*45*10^(-5);
tic
for iter1 = 1:2
   TrM= computer_trim(shape,pM,res);
   Trim= 0.35;
   TrAM = TrM;  % Trimed Adjacency Matrix
   LookTable = [];  % save i,j where TrAM(i,j) == 1 for random selection.
                    % Up Right TriMatrix
   for i=1:N-1  % change to undirected graph
       for j=i+1:N
           if(TrAM(i,j)>Trim||TrAM(j,i)>Trim)
               LookTable = [LookTable(:,:);[i j]];
           end
       end
   end
   
   MijAllE = [];    % Mij for All Edge
   createMijAllE(shape,LookTable,TrM,pM,MoveStep,Trim);

   iNumMax = 0;
   for iterator = 1:50
        [RMSTAM,RMSTtable] = RMST(LookTable);                  % Random Minimum Spanning Tree Adjacent Matrix
%        for i=1:100
%        [RMSTAM,RMSTtable] = RMST1(LookTable);
%        end
       %toc                                                   % Up Right TriMatrix
       ReachedV = zeros(N,1);
       MijAllETmp = MijAllE;
       PMforR = GenPM(RMSTtable);                             % pM for RANSAC %PMforR = GenPMfromMA(RMSTtable,pM);

       restEdge = setdiff(LookTable,RMSTtable,'rows');
       dRmax = 0.05;
       dtmax = 1;
       [inlineNum, TrRAM] = RANSAC(PMforR, restEdge, RMSTAM); % Trimed RANSACed Adjacent Matrix % Inline Number
       if(inlineNum > iNumMax)
           iNumMax = inlineNum;
           TrM = TrRAM;
           pMRANSAC = PMforR;
       end
   end
   pM = pMRANSAC;
   toc
end
%TrM= computer_trim(shape,pM,res);

while ((iter<30)&(err>(ERROR)))
    iter= iter+1
    D= [];   num= 0;  err= 0;
%     if (iter<4&&iter>1)
%        TrM= computer_trim(shape,pM,res);
%        Trim= 0.3;
%        TrM(TrM>Trim)=1;
%     end
    toc
    for i=1:N
        for j= 1:N
            if((i~=j)&(TrM(i,j)==1))  %?4 >Trim  ==1
                num= num+1;
                Mij= inv(pM(i).M)*pM(j).M;  % Mij derived from M which is estimated.
                                            % use it here to obtain R0 and
                                            % t0 to speed up ICP? Nope, it
                                            % is used to create the initial
                                            % state.
                [R0,t0]= M2Rt(Mij);
                Model= shape{i,1}'*1000; % why multiply 1000?
                Data= shape{j,1}'*1000;
                [R, t] = FastTrICP(Model(:,1:res:end), Data(:,1:res:end), R0, t0, i, MoveStep); % use R0, t0 to speed up?
                                                                                                % why need i?5
                pdM(num).M= Rt2M(R,t);  % real Mij
                pdM(num).i= i;
                pdM(num).j= j;
                Dij= gen_Dij(i,j,N);
                D= [D;Dij];
            end
        end
    end
    preM= pM;
    pM= Motion_Average(pdM,pM,D,num,N);   %Averaging using Lie group
    err= com_err(preM,pM)   %calculate the change for deciding whether we reach defined precising.
end
toc
ObjV= com_objv(pM,shape,res)/N
figure
obtain_shape(shape,pM);
%plane(1,-20.1,-19.8)   %Bunny
%plane(2,149.8,150.2)
plane(2,99.8,100.2)
%plane(2,149.8,150.2,Model)
%plane(1,-20.2,-19.8, Model)

