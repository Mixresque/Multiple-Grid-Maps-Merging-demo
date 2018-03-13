function PMforR = GenPM(RMSTtable)

global N MijAllETmp
RMSTtable = [RMSTtable; RMSTtable(:,2) RMSTtable(:,1)];
jlist = iter(1,RMSTtable);
PMforR(1).M= eye(4);
for i=2:N
    PMforR(i).M = MijAllETmp(1,i).M;
end



function jlist = iter(i,RMSTtable)
global ReachedV MijAllETmp

ReachedV(i) = 1;
[count, ~] = size(RMSTtable);
jlist = [];
jlist(1) = i;
for k=1:count
    if(RMSTtable(k,1)==i && ReachedV(RMSTtable(k,2))==0)
        jlist2 = iter(RMSTtable(k,2),RMSTtable);
        [countj, ~] = size(jlist2);
        for t=2:countj
            MijAllETmp(i,jlist2(t)).M = MijAllETmp(i,RMSTtable(k,2)).M*MijAllETmp(RMSTtable(k,2),jlist2(t)).M;
        end
        jlist = [jlist; jlist2];
    end
end