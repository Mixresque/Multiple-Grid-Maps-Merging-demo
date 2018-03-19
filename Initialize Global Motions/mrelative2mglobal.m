% mrelative2mglobal  Estimate global motions from a minimal connected
%                    graph of relative motions. 
% globalMotions = mrelative2mglobal(RelativeMotions, adjac)
% Get global motions with the relative motions of edges that exist
% on adjacency matrix adjax,

function globalMotions = mrelative2mglobal(RelativeMotions, adjac)
    n = size(RelativeMotions,1);
    globalMotions = cell(1,n);
    visited = zeros(n,1);            % 0 as unvisited
    
    globalMotions{1} = eye(3);
    adjac = adjac + adjac';
    visited(1) = 1;
    [visited,globalMotions] = visitPoint(1,adjac,visited,globalMotions,RelativeMotions);
    
%%
function [visited,globalMotions] = visitPoint(x,adjac,visited,globalMotions,RelativeMotions)
    que = find(adjac(x,:)==1);
    for i = 1:size(que,2)
        if visited(que(i))==1
            continue;
        end
        if (que(i)<=x)
            tmp_rm = RelativeMotions{que(i),x};
            globalMotions{1,que(i)} = globalMotions{1,x}*tmp_rm;
%             disp(join(['M',num2str(que(i)),' = M',num2str(x),' * M ',num2str(que(i)),' ',num2str(x)]))
        else
            tmp_rm = RelativeMotions{x,que(i)};
            globalMotions{1,que(i)} = globalMotions{1,x}*tmp_rm;
%             disp(join(['M',num2str(que(i)),' = M',num2str(x),' * M ',num2str(x),' ',num2str(que(i))]))
        end
    end
    for i = 1:size(que,2)
        if(visited(que(i),1)==0)
            visited(que(i),1) = 1;
            [visited,globalMotions] = visitPoint(que(i),adjac,visited,globalMotions,RelativeMotions);
        end
    end
    
    



