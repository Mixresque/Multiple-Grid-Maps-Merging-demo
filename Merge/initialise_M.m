function p= initialise_M(np)

global RotTran

p(1).M= eye(4);
for i=2:np 
    R = OulerToRota(RotTran(1,i-1));
    t = RotTran(2:3,i-1);
    t(3) = 0;    
    p(i).M=Rt2M(R,t);  
end









