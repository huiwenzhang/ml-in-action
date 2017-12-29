%%朴素贝叶斯算法Matlab实现
clear all;
close all;
clc;
load fisheriris
X = meas;
Y = species;
Mdl = fitcnb(X,Y)  %%训练朴素贝叶斯模型
Mdl.ClassNames  %%对模型中的（分类名称）参数进行显示查看
Mdl.Prior        %%对模型中的（先验概率）参数进行显示查看
