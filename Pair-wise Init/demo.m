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
MSE = zeros(demo_n, demo_n);
map = cell(demo_n, 2);
% for demo_i = 1:demo_n
%     RelativeMotions(demo_i, demo_i) = mat2cell(eye(3), 3, 3);
% end

Maps = ('output/Maps.mat');
PairwiseResults = ('output/PairwiseResults.mat');
fmsg=fopen('output/pair_test.txt','w+');
for demo_i = 1:demo_n-1                                           % Obtain all relative motions
    im1 = imread(join(['data\Fr',num2str(demo_i),'.png']));
    for demo_j = demo_i+1:demo_n
        fprintf(fmsg,'Map %d - Map %d\r\n', demo_i, demo_j);
        
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
        [R, t, MSE(demo_i, demo_j)]= TrICP(Mmap,Dmap,R0,t0);       
        RelativeMotions(demo_i, demo_j) = mat2cell([R,t;0,0,1], 3, 3);                              % Applying the TrICP algorithm 
        
        topology(demo_i, demo_j) = 1;
            
    end
    demo_tmp = size(Model);
    m_tmp = Model';
    m_tmp(:,3) = 0;
    map(demo_i, 1) = mat2cell(m_tmp,demo_tmp(2),demo_tmp(1)+1);                                               % Save maps No.1 ~ n-1
end
demo_tmp = size(Data);
m_tmp = Data';
m_tmp(:,3) = 0;
map(demo_n, 1) = mat2cell(m_tmp,demo_tmp(2),demo_tmp(1)+1);
draw_graph(topology,0);

RelativeMotions(1,1) = mat2cell(eye(3), 3, 3);
save(PairwiseResults, 'RelativeMotions','MSE');                                 % Save relative motions and trimmed mse
save(Maps, 'map');                                                         % Save maps
fclose(fmsg);

type('output/pair_test.txt');
