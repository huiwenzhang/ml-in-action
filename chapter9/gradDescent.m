function [costVal, theta] = graDescent(train, label, alpha, maxCycls)
% 利用梯度下降法求解回归系数
% 输入：
%     train：矩阵，训练集
%     label：矩阵，标签
%     alpha：学习步长
%     maxCycls：迭代次数
% 输出：
%     costVal:代价函数值
%     theta：向量，返回的回归系数

% Author：huiwen
[m,n] = size(train);
theta0 = ones(n, 1);    %列向量，特征个数
for i = 1:maxCycls
    

