% Matlab 自带K中心点算法函数kmedoids实现
clc;
clear;
close all;
X = [randn(100,2)*0.75+ones(100,2);randn(100,2)*0.5-ones(100,2)];%产生两组随机数据
[idx,C,sumd,d,midx,info] = kmedoids(X,2,'Distance','cityblock');%利用K中心点算法进行分组
plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',7) %绘制分组后第一组的数据
hold on
plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',7) %绘制分组后第二组的数据
plot(C(:,1),C(:,2),'co','MarkerSize',7,'LineWidth',1.5)%绘制第一组和第二组数据的中心点
legend('Cluster 1','Cluster 2','Medoids','Location','NW');
title('Cluster Assignments and Medoids');
hold off