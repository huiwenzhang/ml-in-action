clear all;
close all;
clc;
%%利用高斯分布，生成动作片数据和标签
aver1=[8 3];  %均值
covar1=[2 0;0 2.5];  %2维数据的协方差
data1=mvnrnd(aver1,covar1,100);   %产生高斯分布数据
for i=1:100    %另高斯分布产生数据中的复数为0
    for j=1:2   %因为打斗镜头数和接吻镜头数不能为负数
        if data1(i,j)<0
            data1(i,j)=0;
        end
    end
end
label1=ones(100,1);  %将该类数据的标签定义为1
plot(data1(:,1),data1(:,2),'+');  %用+绘制出数据
axis([-1 12 -1 12]); %设定两坐标轴范围
xlabel('打斗镜头数'); %标记横轴为打斗镜头数
ylabel('接吻镜头数'); %标记纵轴为接吻镜头数
hold on;
%%利用高斯分布，生成爱情片数据和标签
aver2=[3 8];
covar2=[2 0;0 2.5];
data2=mvnrnd(aver2,covar2,100); %产生高斯分布数据
for i=1:100    %另高斯分布产生数据中的复数为0
    for j=1:2  %因为打斗镜头数和接吻镜头数不能为负数
        if data2(i,j)<0
            data2(i,j)=0;
        end
    end
end
plot(data2(:,1),data2(:,2),'ro');  %用o绘制出数据
label2=label1+1; %将该类数据的标签定义为2
data=[data1;data2];
label=[label1;label2];
K=11;   %两个类，一般K取奇数有利于测试数据属于那个类
%测试数据，KNN算法看这个数属于哪个类，测试数据共计25个
%打斗镜头数遍历3-7，接吻镜头书也遍历3-7
for movenum=3:1:7
    for kissnum=3:1:7
        test_data=[movenum kissnum];  %测试数据，为5X5矩阵
        %%下面开始KNN算法，显然这里是11NN。
        %求测试数据和类中每个数据的距离，欧式距离（或马氏距离）
        distance=zeros(200,1);
        for i=1:200
            distance(i)=sqrt((test_data(1)-data(i,1)).^2+(test_data(2)-data(i,2)).^2);
        end
        %选择排序法，只找出最小的前K个数据,对数据和标号都进行排序
        for i=1:K
            ma=distance(i);
            for j=i+1:200
                if distance(j)<ma
                    ma=distance(j);
                    label_ma=label(j);
                    tmp=j;
                end
            end
            distance(tmp)=distance(i);  %排数据
            distance(i)=ma;
            label(tmp)=label(i);        %排标签
            label(i)=label_ma;
        end
        cls1=0; %统计类1中距离测试数据最近的个数
        for i=1:K
            if label(i)==1
                cls1=cls1+1;
            end
        end
        cls2=K-cls1;    %类2中距离测试数据最近的个数
        if cls1>cls2
            plot(movenum,kissnum, 'k.'); %属于类1（动作片）的数据画小黑点
        else
            plot(movenum,kissnum, 'g*'); %属于类2（爱情片）的数据画绿色*
        end
        label=[label1;label2]; %更新label标签排序
    end
end
