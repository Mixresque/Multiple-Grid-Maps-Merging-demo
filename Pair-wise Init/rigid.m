function [R,t]= rigid(M,S)
 [R, t] = reg(M', S');
end

% [s, R, t] = reg(M', S');
% R= inv(R);
% X(1,1)=s*R(1,1); 
% X(1,2)=R(1,2); 
% X(2,1)=R(2,1); 
% X(2,2)=s*R(2,2); 
% X(3,1)=t(1); 
% X(3,2)=t(2);
% X(1,3)=0;
% X(2,3)=0;
% X(3,3)=1;
% T = maketform('affine', X);
% end

function [R1, t1] = reg(M, S)
n = size(M,2); 
mm = mean(M,2);
ms = mean(S,2); 
Mshifted = [M(1,:)-mm(1); M(2,:)-mm(2)];
Sshifted = [S(1,:)-ms(1); S(2,:)-ms(2)];
K = Sshifted*Mshifted';
K = K/n;
[U A V] = svd(K);
R1 = V*U';
if det(R1)<0
    B = eye(2);
    B(2,2) = det(V*U');
    R1 = V*B*U';
end
t1 = mm - R1*ms;
end
