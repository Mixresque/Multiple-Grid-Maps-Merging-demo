function V= matrix2vec(M)

V(1,1)= M(2,1); 
V(2,1)= M(3,1);  
V(3,1)= M(3,2);
V(4:6,1)= (M(1:3,4));