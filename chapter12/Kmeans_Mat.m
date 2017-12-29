% %Matlab 自带K均值算法函数kmeans实现
clc;
clear;
close all;
X = [randn(100,2)*0.75+ones(100,2);randn(100,2)*0.5-ones(100,2)]; %产生两组随机数据
[idx,C] = kmeans(X,2,'Distance','cityblock','Replicates',5);%利用K均值算法进行分组
plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',12) %绘制分组后第一组的数据
hold on
plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',12) %绘制分组后第二组的数据
plot(C(:,1),C(:,2),'kx','MarkerSize',15,'LineWidth',3) %绘制第一组和第二组数据的中心点
legend('Cluster 1','Cluster 2','Centroids','Location','NW') 
title 'Cluster Assignments and Centroids'
hold off
