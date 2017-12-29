clc
clear
close all
%% 产生数据
rng default;  % For reproducibility
mu1 = [1 2];
sigma1 = [3 .2; .2 2];
mu2 = [-2 -4];
sigma2 = [2 0; 0 1];
X = [mvnrnd(mu1,sigma1,200); mvnrnd(mu2,sigma2,100)];%2个高斯的数据样本
n = size(X,1);

%% dbscan聚类
label = dbscan(X,2);