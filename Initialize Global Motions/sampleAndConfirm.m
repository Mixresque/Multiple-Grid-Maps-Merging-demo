% sampleAndConfirm  Sample minimal connected graphs and confirm
%                   reliability of relative motions. 

function  sampleAndConfirm(iter_MCS, thr_MCS, support_best)    
global RelativeMotions MSE mglobal_best mcs_best n
    mglobal_best = cell(1,n);
    mcs_best = zeros(n);
    for i = 1:iter_MCS
        edges = find(~cellfun(@isempty,RelativeMotions));
        sub = sampleSubgraph(RelativeMotions, MSE);
        mglobal = mrelative2mglobal(RelativeMotions, sub);
        mcs = find(sub);
        voters = setdiff(edges, mcs);
    %     voters = edges;
        svoter = size(voters,1);
        support = 0;
        drift = zeros(svoter,1);
    %     disp(num2str(i));
        for j = 1:svoter
            fs = ceil(voters(j)/n);          % j
            fe = voters(j) - fs*n+n;         % i
    %         disp (join([num2str(fs),' ',num2str(fe),' ',num2str(edges(j))]))
            drift(j) = norm( RelativeMotions{fe,fs}\(mglobal{fe}\mglobal{fs}) - i, 'fro');
            if (drift(j) < thr_MCS)
                support = support + 1;
            end
    %         disp (join([num2str(fe),' ',num2str(fs), ' ',num2str(drift(j))]))
        end

        if(support > support_best)
            mglobal_best = mglobal;
            mcs_best = sub;
            for j = 1:svoter
                if (drift(j) >= thr_MCS)
                    fs = ceil(voters(j)/n);          % j
                    fe = voters(j) - fs*n+n;         % i
                    test = ~cellfun(@isempty,RelativeMotions);
                    test(fe,fs) = 0;
                    g = test+test'+eye(n);        % Calculate reachability matrix
                    g = g^n;
                    if (isequal(g~=0,ones(n)))
                        RelativeMotions{fe,fs} = [];
                        MSE(fe,fs) = 0;
                    end
                end
            end
        end
    end