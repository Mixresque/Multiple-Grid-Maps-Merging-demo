function M= Rt2M(R,t)   

   M(1:2,1:2)= R;
   M(3,3)= 1;
   M(1:2,3)= t;