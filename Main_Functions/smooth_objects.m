function [ I_out ] = smooth_objects( I_in , nd )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

if nargin == 1
    nd = 12;
end

[B,L] = bwboundaries(I_in);

I_out = zeros(size(I_in));

num_obj = length(B);

B = Fourier_smooth_object_boundarys(B,nd);

for i = 1:num_obj
     
    I_temp = zeros(size(I_in));
    I_temp(L==i) = 1;
    
    xy = B{i};
    x = xy(:,1);
    y = xy(:,2);
    
    J = regionfill(I_temp,y,x);
    J(J >= 1) = 0;
    J(J > 0) = 1;
    
    I_out = I_out + J;    
end


end

