% Matlab 自带SVM算法函数svmtrain实现，并依靠svmclassify对建立的SVM模型对测试数据进行分类。
clc;
clear;
close all;
traindata=[0,1;-1,0;2,2;3,3;-2,-1;-4.5,-4;2,-1;-1,-3]; %生成样本的属性数据
lable=[1,1,-1,-1,1,1,-1,-1]'; %样本标签
testdata=[5,2;3,1;-4,-3]; %测试数据的属性数据
svm_struct=svmtrain(traindata,lable,'Showplot',true);%训练SVM模型
testlable=svmclassify(svm_struct,testdata,'Showplot',true); %依据测试样本对模型进行测试
hold on;
plot(testdata(:,1),testdata(:,2),'ro','MarkerSize',12);
hold off