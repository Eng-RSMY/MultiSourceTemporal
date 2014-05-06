function [W , tensorW ] = MLMTL_Tucker( X, Y, Ps )
%TUCKER Summary of this function goes here
%   Detailed explanation goes here: implementation of the Tucker product
%   algorithm in Multilinear Multitask Learning




% minimize over G
[G_1 f_G_1] = my_grad_descent(@objc_G,@grad_G,G_1, A, X, Y);
 
% minimize over A1
[A1 f_A1] = grad_descent_A1(G_1, A, X, Y);

% minimize over A2
[A2,f_A2] = grad_descent_An(G_1,A,X,Y,2);

% minimize over A3
[A3,f_A3] = grad_descent_An(G_1,A,X,Y,3 ,1e-5);



 


end
