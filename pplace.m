function [B] = pplace(soutput,sensor,dim)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Bv = zeros(dim,1);
for i = 1:dim
    if isequal(soutput(i,:),sensor)
        Bv(i) = 1;
    end
end
B = diag(Bv);
end

