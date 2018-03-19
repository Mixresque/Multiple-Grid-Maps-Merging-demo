% sampleSubgraph  Randomly get a minimal connected subgraph 
%                 with prescribed probabilities. 
% A = sampleSubgraph(initial_graph, MSE)
% Randomly sample a subgraph with probabilities inversely 
% proportional to its weight and return the adjacency matrix
% A of this subgraph. 

function A = sampleSubgraph(initial_graph, weight)
    n = size(initial_graph,1);
    % Get all existing edges and respective weights
    edge_exist = ~cellfun(@isempty,initial_graph);
    tmp = find(edge_exist);
    % edge = [tmp-ceil(tmp/n)*n+n,ceil(tmp/n),1./MSE(tmp)];
    edge = [tmp,1./weight(tmp)];
    g = zeros(n);
    % Graph-based random sampling
    while (~isequal(g~=0,ones(n)))
        A = zeros(n);
        x = zeros(n-1,1);       % Chosen edges
        prob = edge(:,2)';
        s_prob = sum(prob);
        for i = 1:n-1
            tmp = sum( rand*s_prob >= cumsum([0, prob]) );
            while (~isempty(find(x==tmp)))
                tmp = sum( rand*s_prob >= cumsum([0, prob]) );
            end
            x(i) = tmp;
        end    
        A(edge(x,1)) = 1;               % Get adjacency matrix
        g = A+A'+eye(n);        % Calculate reachability matrix
        g = g^n;
    end
    showSubgraph(A,edge_exist);