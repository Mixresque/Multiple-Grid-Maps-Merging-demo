function  err= com_err(preM,pM)

global N
err= 0;
for i=1:N
    R0= preM(i).M(1:2,1:2);
    R= pM(i).M(1:2,1:2);
    err= sum(sum(abs(R-R0))')+err;
end