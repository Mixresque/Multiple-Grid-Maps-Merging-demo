% sampleAndConfirm  Sample minimal connected graphs and confirm
%                   reliability of relative motions. 
% support_best = sampleAndConfirm(iter_MCS, thr_r, thr_t, support_best)  
% Variable iter_MCS sets the number of iterations, thr_r and thr_t the
% threshold for judging reliability, and support_best the least supporting edges
% a good MCS should get. Return the number of supporting edges for the
% best MCS found. 

function support_best = sampleAndConfirm(iter_MCS, thr_r, thr_t, support_best)    
    global RelativeMotions MSE mglobal_best mcs_best n reliableRM
    err_r_min = 0;
    for i = 1:iter_MCS
        reliableRM = ~cellfun(@isempty,RelativeMotions);
        edges = find(reliableRM);
        sub = sampleSubgraph(RelativeMotions, MSE);
        mglobal = mrelative2mglobal(RelativeMotions, sub);
        mcs = find(sub);
        voters = setdiff(edges, mcs);
    %     voters = edges;
        svoter = size(voters,1);
        support = 0;
        err_r = 0;
        drift_r = zeros(svoter,1);
        drift_t = zeros(svoter,1);
        disp(num2str(i));
        for j = 1:svoter
            fs = ceil(voters(j)/n);          % j
            fe = voters(j) - fs*n+n;         % i
    %         disp (join([num2str(fs),' ',num2str(fe),' ',num2str(edges(j))]))
            [R, t] = motion2Rt(mglobal{fe}\mglobal{fs});
            [R0, t0] = motion2Rt(RelativeMotions{fe,fs});
            drift_r(j) = norm(R-R0);
%             drift_r(j) = sum(sum(abs(R-R0)));
            drift_t(j) = norm(t-t0);
            if (drift_r(j) <= thr_r && drift_t(j) <= thr_t)
                support = support + 1;
                err_r = err_r + drift_r(j);
            end
            disp (join([num2str(fe),' ',num2str(fs), '  r: ',num2str(drift_r(j)),'  t: ',num2str(drift_t(j))]))
        end
        % Delete unreliable relative motions if new MCS gets best support
        if(support > support_best || (support == support_best && err_r < err_r_min) )
            mglobal_best = mglobal;
            mcs_best = sub;
            support_best = support;
            err_r_min = err_r;
            disp(num2str(err_r));
            for j = 1:svoter
                if (drift_r(j) > thr_r || drift_t(j) > thr_t)
                    fs = ceil(voters(j)/n);          % j
                    fe = voters(j) - fs*n+n;         % i
%                     test = ~cellfun(@isempty,RelativeMotions);
%                     test(fe,fs) = 0;
%                     g = test+test'+eye(n);        % Calculate reachability matrix
%                     g = g^n;
%                     if (isequal(g~=0,ones(n)))
                        RelativeMotions{fe,fs} = [];
                        MSE(fe,fs) = 0;
%                     end
                end
            end
        end
    end