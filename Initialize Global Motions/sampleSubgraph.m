% sampleSubgraph  Randomly get a minimal connected subgraph 
%                 with prescribed probabilities. 
% A = sampleSubgraph(initial_graph, MSE)
% Randomly sample a subgraph with probabilities inversely 
% proportional to its weight and return the adjacency matrix
% A of this subgraph. 

function A = sampleSubgraph(initial_graph, weight)
    n = size(initial_graph,1);
    
    % Get all existing edges and respective weights
    findEdges = ~cellfun(@isempty,initial_graph);
    edge_exist = find(findEdges);
    
    % edge = [tmp-ceil(tmp/n)*n+n,ceil(tmp/n),1./MSE(tmp)];
    % edge = [edge_exist,1./weight(edge_exist)];
    g = zeros(n);
    
    % Graph-based random sampling
    while (~isequal(g~=0,ones(n)))
        edge = [edge_exist,1./weight(edge_exist)];
        x = zeros(n-1,1);       % Chosen edges
        for i = 1:n-1
            prob = edge(:,2)';
            s_prob = sum(prob);
            tmp = sum( rand*s_prob > cumsum([0, prob]) );
%             while (~isempty(find(x==tmp)))
%                 tmp = sum( rand*s_prob >= cumsum([0, prob]) );
%             end
            x(i) = edge(tmp,1);
            edge(tmp,:) = [];
        end
        A = zeros(n);
        A(x) = 1;               % Get adjacency matrix
        g = A+A'+eye(n);        % Calculate reachability matrix
        g = g^n;
    end
    
    % showSubgraph(A,findEdges);
    