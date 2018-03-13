function  Dij= gen_Dij(i,j,N)

Dij= zeros(6,6*N);
id1= i*6-5;
id2= j*6-5;
Dij(1:6,(id1:(id1+5)))= -eye(6);
Dij(1:6,(id2:(id2+5)))= eye(6);