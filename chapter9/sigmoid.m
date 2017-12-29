function val = sigmoid(inX)
% 计算线性输出后的s变换
[m,n] = size(inX);
val = zeros(m,1);
val = 1.0 / (1 + exp(-inX));