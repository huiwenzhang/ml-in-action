%%CART决策树算法Matlab实现
clear all;
close all;
clc;
load fisheriris  %载入样本数据
t = fitctree(meas,species,'PredictorNames',{'SL' 'SW' 'PL' 'PW'})%定义四种属性显示名称
view(t) %在命令行窗口中用文本显示决策树结构
view(t,'Mode','graph') %图形显示决策树结构

