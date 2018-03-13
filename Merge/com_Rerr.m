function Rerr= com_Rerr(pM,RigTB)
global N
Rerr= 0;
for i=2:N
    Re= pM(i).M(1:3,1:3);
    Rt= q2rot(RigTB(i,4:7));
    Rerr= sum(sum(Re-Rt))'+Rerr;
end
    
 function r=q2rot(q)
w=q(4);
x=q(1);
y=q(2);
z=q(3);
 
r=zeros(3,3);
r(1,1)=1-2*y*y-2*z*z;
r(1,2)=2*x*y+2*w*z;
r(1,3)=2*x*z-2*w*y;
 
r(2,1)=2*x*y-2*w*z;
r(2,2)=1-2*x*x-2*z*z;
r(2,3)=2*z*y+2*w*x;
 
r(3,1)=2*x*z+2*w*y;
r(3,2)=2*y*z-2*w*x;
r(3,3)=1-2*x*x-2*y*y;
r=r';