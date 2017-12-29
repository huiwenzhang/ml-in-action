clc
clear
close
load ionosphere; % 加载数据，ionosphere是UCI上的一个数据集，具有351个观测，34个特征，二分类标签：good & bad
ClassTreeEns = fitensemble(X,Y,'AdaBoostM1',100,'Tree'); % 利用AdaBoost算法训练100轮，弱学习器类型为决策树，返回一个ClassificationEnsemble类
rsLoss = resubLoss(ClassTreeEns,'Mode','Cumulative'); % 计算误差，cumulative表示综合1：T分类器的误差
plot(rsLoss); %绘制训练次数与误差关系
xlabel('Number of Learning Cycles');
ylabel('Resubstitution Loss');
Xbar = mean(X); % 构造一个新的样本
[ypredict score] = predict(ClassTreeEns,Xbar) % 预测新的样本，利用predict方法
% ypredict:预测的标签 score：当前样本点属于每个类的可信度，分值越大，置信度越高
view(ClassTreeEns.Trained{5}, 'Mode', 'graph') ;% 显示训练的弱分类器
