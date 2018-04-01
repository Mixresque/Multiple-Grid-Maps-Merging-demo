% motionAverage  Perform motion average algorithm to refine initial
%                global motions with all reliable relative motions. 
% gm = motionAverage(gm, rmreliability, rm)
% Refine global motions using all reliable relative motions with 
% motion average algorithm. Input variable gm is the initial coarse
% global motions, rmreliability a nxn matrix marking out all the 
% reliable relative motions, rm is all the available relative 
% motions. Return gm as the final fine global motions. 

function gm = motionAverage(gm, rmreliability, rm)
    rrms = find(rmreliability);
    n = size(rmreliability, 1);
    n_edge = size(rrms, 1);
    tmp = ceil(rrms/n);
    rm_pos = [rrms-tmp*n+n, tmp];           % i, j of Mij
    d = zeros(3*n_edge, 3*n);
    for i = 1:n_edge
        d(3*i-2, 3*rm_pos(i,1)-2) = -1;
        d(3*i-1, 3*rm_pos(i,1)-1) = -1;
        d(3*i, 3*rm_pos(i,1)) = -1;
        d(3*i-2, 3*rm_pos(i,2)-2) = 1;
        d(3*i-1, 3*rm_pos(i,2)-1) = 1;
        d(3*i, 3*rm_pos(i,2)) = 1;
    end
    d = pinv(d);
    epsilon = 10^(-4);
    max = 100;
    diff = 10;
    i = 0;
    while ( diff>epsilon && i<max )
        i = i+1;
        dV = [];
        for j = 1:n_edge
            dM = gm{rm_pos(j,1)}*rm{rm_pos(j,1),rm_pos(j,2)}/(gm{rm_pos(j,2)});
            dm = logm(dM);
            dv = [dm(1,2);dm(1:2,3)];
            dV = [dV;dv];
        end
        delta = d*dV;
        for j = 2:n
            dvi = delta(3*j-2:3*j,1);
            dmi = [1, dvi(1), dvi(2); -dvi(1), 1, dvi(3); 0, 0, 1];
            gm{j} = expm(dmi)*gm{j};            
        end   
        diff = norm(delta);
    end
