function pM= Motion_Average(pdM,pM,D,num,N)

erro= 10;
Dpi= pinv(D);
ii= 0;
while (erro>10^(-4))&(ii<100)
   V= [];    Vo= [];
   ii=ii+1;
    for id= 1:num
        i= pdM(id).i;
        j= pdM(id).j;
        Mij= pdM(id).M;
        dMij= pM(i).M*Mij*inv(pM(j).M);
        dmij= logm(dMij);
        vij= matrix2vec(dmij);
        V= [V;vij];
    end
    dV= Dpi*V;
    for i= 2:N
        id= i*6-5;
        pM(i).M= expm(vec2matrix(dV(id:id+5,:)))*pM(i).M;
        Vo= [Vo;dV(id:id+2)];
    end
    erro= sum(abs(Vo));
end