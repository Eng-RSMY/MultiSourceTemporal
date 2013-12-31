% This script is used for testing the gradients
clc
clear

p = 10;
T = 100;

S = cell(1);
S{1} = zeros(p);
b = zeros(p, 1);

series = randn(p, T) > 0.5;
series = 1.0*series;
index = 2:T-3;

[obj, G] = gradPoisson(series, S, b, index);

i = 2;
j = 3;
delta = 1e-8;
S{1}(i, j) = S{1}(i, j) + delta;

[obj2, ~, Gb] = gradPoisson(series, S, b, index);

disp(G{1}(i, j))
disp((obj2 - obj)/delta)

b(i) = b(i) + delta;

[obj3] = gradPoisson(series, S, b, index);

disp(Gb(i))
disp((obj3 - obj2)/delta)