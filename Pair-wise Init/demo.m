%% Demo start
clc
close all
global TrMin TrMax Model Data demo_i demo_j fmsg
TrMin= 0.2; 
TrMax= 1.0;
demo_n = 11;                                            % Number of maps to be merged
tic

topology = zeros(demo_n, demo_n);
% RelativeMotions = zeros(3,demo_n*(demo_n-1)/2);
% demo_k = 1;
RelativeMotions = cell(demo_n, demo_n);
RotTran = zeros(3,demo_n-1);
map = cell(demo_n, 2);
for demo_i = 1:demo_n
    RelativeMotions(demo_i, demo_i) = mat2cell(eye(3), 3, 3);
end

RotTranM = ('output/RotTranM.mat');
Maps = ('output/Maps.mat');
fmsg=fopen('output/pair_test.txt','w+');
for demo_i = 1:demo_n-1                                           % Obtain all relative motions
    for demo_j = demo_i+1:demo_n
        fprintf(fmsg,'Map %d - Map %d\r\n', demo_i, demo_j);
        
        im1 = imread(join(['data\Fr',num2str(demo_i),'.png']));
        im2 = imread(join(['data\Fr',num2str(demo_j),'.png'])); 

        [pts1 pts2] = SIFTmatch( im1, im2, 0, true );                      % Obtain the feature matches
        try
            [R0,t0, best_ptsA] = ransac(pts1, pts2, 'rig_lsq', 2);             % Estimate the initial merging parameters by the consistent feature matches
        catch
            fprintf(fmsg,'%d matching %d failed\r\n\r\n', demo_i, demo_j);
            % demo_k = demo_k+3;
            continue;
        end
        fprintf(fmsg,'%d matched %d successfully\r\n\r\n', demo_i, demo_j);
        Mmap= rgb2gray(im1);
        Dmap= rgb2gray(im2);
        [R,t]= TrICP(Mmap,Dmap,R0,t0);                                     % Applying the TrICP algorithm 
        
        % rotang = atan(R(2,1)/R(1,1))+pi*(sign(R(2,1))-abs(sign(R(2,1))))/(-2);  % Get rotation angle
        % RelativeMotions(demo_k) = rotang;
        % RelativeMotions(demo_k+1) = t(1);
        % RelativeMotions(demo_k+2) = t(2);
        % demo_k = demo_k+3;
        topology(demo_i, demo_j) = 1;
        
        RelativeMotions(demo_i, demo_j) = mat2cell([R,t;0,0,1], 3, 3);
        RelativeMotions(demo_j, demo_i) = mat2cell([R,t;0,0,1], 3, 3);
            
    end
    demo_tmp = size(Model);
    map(demo_i, 1) = mat2cell(Model,demo_tmp(1),demo_tmp(2));                                               % Save maps No.1 ~ n-1
end
demo_tmp = size(Data);
map(demo_i+1, 1) = mat2cell(Data,demo_tmp(1),demo_tmp(2));
draw_graph(topology,0);

% Calculate global motions - demo
for demo_i = 2:demo_n
    for demo_k = 2:demo_n
        if isempty(cell2mat(RelativeMotions(1,demo_i)))
            if ~isempty(cell2mat(RelativeMotions(1,demo_k))) && ~isempty(cell2mat(RelativeMotions(demo_k,demo_i)))
                RelativeMotions(1,demo_i) = mat2cell(cell2mat(RelativeMotions(1,demo_k))*cell2mat(RelativeMotions(demo_k,demo_i)),3,3);
            end
        end
    end    
end

for demo_i = 1:demo_n-1
    demo_tmp = cell2mat(RelativeMotions(1,demo_i+1));
    RotTran(demo_i*3-2) = atan(demo_tmp(2,1)/demo_tmp(1,1))+pi*(sign(demo_tmp(2,1))-abs(sign(demo_tmp(2,1))))/(-2);
    RotTran(demo_i*3-1) = demo_tmp(1,3);
    RotTran(demo_i*3) = demo_tmp(2,3);
end
save(RotTranM, 'RotTran');                                                 % Save global motions
save(Maps, 'map');                                                         % Save maps
fclose(fmsg);

type('output/pair_test.txt');
