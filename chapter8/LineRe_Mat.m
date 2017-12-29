%Matlab线性回归算法Matlab实现
clear all;
close all;
clc;
load carsmall  %载入汽车数据
tbl = table(Weight,Acceleration,MPG,'VariableNames'...
,{'Weight','Acceleration','MPG'});
lm = fitlm(tbl,'MPG~Weight+Acceleration') %以Weight和Acceleration为自变量，MPG为因变量的线性回归
plot3(Weight,Acceleration,MPG,'*') %绘制数据点图
hold on
axis([min(Weight)+2 max(Weight)+2 min(Acceleration)+1 max(Acceleration)+1 min(MPG)+1 max(MPG)+1]) 
title('二元回归')  %编辑图形名称
xlabel('Weight')  %编辑x坐标轴名称
ylabel('Acceleration')  %编辑y坐标轴名称
zlabel('MPG')  %编辑y坐标轴名称
X=min(Weight):20:max(Weight)+2 ;  %生成用于绘制二元拟合面的X轴数据
Y=min(Acceleration):max(Acceleration)+1;%生成用于绘制二元拟合面的Y轴数据
[XX,YY]=meshgrid(X,Y); %生成XY轴的网格数据
Estimate = table2array(lm.Coefficients); %将计算得到的table格式的拟合参数转换为矩阵形式
Z=Estimate(1,1)+Estimate(2,1)*XX+Estimate(3,1)*YY;%计算拟合面的Z轴数据       
mesh(XX,YY,Z) %绘制网格形式的二元拟合面
hold off

