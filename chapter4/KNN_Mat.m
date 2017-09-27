% %Matlab 自带KNN算法函数knnclassify实现
clc
close all;
clear
%生成200个样本数据
training = [mvnrnd([2  2],eye(2), 100); mvnrnd([-2 -2], 2*eye(2), 100)];
%mvnrnd([2  2],eye(2),100)表示随机生成多元正态分布100X2矩阵，每一列以2，2为均值，eye(2)为协方差
%200个样本数据前100标记为标签1，后100个标记为标签2
group = [ones(100,1); 2*ones(100,1)];
%绘制出离散的样本数据点
gscatter(training(:,1),training(:,2),group,'rc','*x');
hold on; 
% 生成待分类样本20个
sample = unifrnd(-2, 2, 20, 2); 
%产生一个100X2,这个矩阵中的每个元素为20 到30之间连续均匀分布的随机数
K=3;%KNN算法中K的取值
cK = knnclassify(sample,training,group,K);
gscatter(sample(:,1),sample(:,2),cK,'rc','os');
