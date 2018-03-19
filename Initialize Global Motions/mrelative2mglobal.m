% mrelative2mglobal  Estimate global motions from a minimal connected
%                    graph of relative motions. 
% globalMotions = mrelative2mglobal(RelativeMotions, adjac)
% Get global motions with the relative motions of edges that exist
% on adjacency matrix adjax,

function globalMotions = mrelative2mglobal(RelativeMotions, adjac)
    n = size(RelativeMotions,1);
    globalMotions = cell(n,1);
    visited = zeros(n,1);            % 0 as unvisited
    
    globalMotions{1} = eye(3);
    adjac = adjac + adjac';
    visited(1) = 1;
    [visited,globalMotions] = visitPoint(1,adjac,visited,globalMotions,RelativeMotions);
    
%%
function [visited,globalMotions] = visitPoint(x,adjac,visited,globalMotions,RelativeMotions)
    que = find(adjac(x,:)==1);
    for i = 1:size(que,2)
        if (isempty(RelativeMotions{x,que(i)}))
            tmp_rm = RelativeMotions{que(i),x};
        else
            tmp_rm = RelativeMotions{x,que(i)};
        end
        globalMotions{que(i),1} = globalMotions{x,1}*tmp_rm;
    end
    for i = 1:size(que,2)
        if(visited(que(i),1)==0)
            visited(que(i),1) = 1;
            [visited,globalMotions] = visitPoint(que(i),adjac,visited,globalMotions,RelativeMotions);
        end
    end
    
    



