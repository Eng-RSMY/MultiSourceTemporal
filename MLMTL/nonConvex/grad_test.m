function [ g ] = grad_test( x )
%GRAD_TEST Summary of this function goes here
%   Detailed explanation goes here
g = [2*x(1) + x(2)
    x(1) + 6*x(2)];


end

