% Generate 10 datasets

tLen = [10, 50, 100, 200];
for i = 1:10
    for t= 1:length(tLen)
        synthGenSLR(tLen(t), i)
    end
end