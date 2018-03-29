% Motion2Rt  Get rotation matrix and transform vector from motion matrix. 
% [R, t] = Motion2Rt(m, d)
% Variable m inputs the origin motion matrix and d stands for number of
% dimensions. Return R as rotation matrix and t as transform vector. If
% d is not given, use default d = 2. 

function [R, t] = Motion2Rt(m, d)
    if nargin<2
    	d = 2;
    end
    R = m(1:d, 1:d);
    t = m(1:d, d+1);
end