%% fisher
clc
clear
close all
load fisheriris
scatter(meas(1:50,1), meas(1:50,2), 15, 'r', 'filled')
hold on
scatter(meas(51:100,1), meas(51:100,2), 15, 'g', 'filled')
scatter(meas(101:end,1), meas(101:end,2), 15, 'b', 'filled')
xlabel('Sepal length (cm)');ylabel('Sepal width (cm)')
f = gcf
set(f, 'Position', [100 100 300 240])
a = gca
title('Fisher Iris Dataset');
set(a, 'FontSize', 9)
box on;

%% 生成高斯混合模型
% 声明GMM需要的参数
clc
clear
close all
Mu = [1 2;-3 -5];                    % 均值
Sigma = cat(3,[2 0;0 .5],[1 0;0 1]); % 方差，cat函数将两个矩阵在某个维上进行连接
P = ones(1,2)/2;                     % 混合系数

% 创建GMM模型
gm = gmdistribution(Mu,Sigma,P);   
% 显示GMM的属性
properties = properties(gm)
 
% 图示GMM的PDF
gmPDF = @(x,y)pdf(gm,[x y]); 
 
f = figure
set(f, 'Position', [100 100 800 400]);
p1 = subplot(121);
ezsurf(gmPDF,[-10 10],[-10 10])
title('PDF of the GMM');
set(p1, 'FontSize', 9)
% 图示CDF
gmCDF = @(x,y)cdf(gm,[x y]); 
 
p2 = subplot(122);
ezsurf(@(x,y)cdf(gm,[x y]),[-10 10],[-10 10])
title('CDF of the GMM');
set(p2, 'FontSize', 9)


%% 拟合一个GMM模型
% 产生两个二维的单高斯模型，并用来产生模拟数据
close all
clear
% 第一个高斯
mu1 = [1 2];
Sigma1 = [2 0; 0 0.5];
% 第二个高斯
mu2 = [-3 -5];
Sigma2 = [1 0;0 1];
rng(1); % 为了重复再现
% 根据两个高斯模型，分别随机产生1000个样本点，并组合在一起
X = [mvnrnd(mu1,Sigma1,1000);mvnrnd(mu2,Sigma2,1000)]; 

% 模型拟合，声明2个成分，gm是一个结构体，保存了拟合模型的参数
gm = fitgmdist(X, 2);

% 画出拟合的高斯模型
y = [zeros(1000,1);ones(1000,1)];   % 两类数据的标签
h = gscatter(X(:,1),X(:,2),y);
% set(gca, 'YLim', [-10 10]);
hold on
ezcontour(@(x1,x2)pdf(gm,[x1 x2]),get(gca,{'XLim','YLim'}))
title('{\bf 散点图和拟合的高斯模型轮廓}')
legend(h,'Model-0','Model-1', 'Location', 'SouthEast')
set(gca, 'YLim', [-8 6], 'XLim', [-6 6], 'FontSize', 9);
set(gcf, 'Position', [100 100 400 300]);
hold off

% 打印参数
properties(gm)
gm.mu
gm.Sigma

%% 产生仿真数据
clear
close all
rng default;  % For reproducibility
mu1 = [1 2];
sigma1 = [3 .2; .2 2];
mu2 = [-1 -2];
sigma2 = [2 0; 0 1];
%2个高斯的数据样本
X = [mvnrnd(mu1,sigma1,200); mvnrnd(mu2,sigma2,100)]; 
n = size(X,1);
 
scatter(X(1:200,1),X(1:200,2),15,'ro','filled');
hold on; 
scatter(X(201:end,1),X(201:end,2),15,'bo','filled');
set(gcf, 'Position', [100 100 450 360]);
title('仿真数据');
legend('cluster-1', 'cluster-2', 'Location', 'SouthEast');
set(gca, 'FontSize', 10);

% 可选参数设置
options = statset('Display','final');
gm = fitgmdist(X,2,'Options',options)
% 画出拟合模型的投影散点图：
hold on
ezcontour(@(x,y)pdf(gm,[x y]),[-6 6],[-6 6]);
title('散点图和拟合GMM模型')
xlabel('x'); ylabel('y');
set(gcf, 'Position', [100 100 450 360]);

% 利用cluster方法聚类
idx = cluster(gm,X);
estimated_label = idx;
ground_truth_label = [ones(200,1); 2*ones(100,1)];
k = find(estimated_label ~= ground_truth_label);
% 标记错误分类的点为数字3
idx(k,1) = 3;

figure;
gscatter(X(:,1),X(:,2),idx);
legend('Cluster 1','Cluster 2','error', 'Location','NorthWest');
title('GMM聚类');
set(gcf, 'Position', [100 100 400 320]);

% 计算后验概率
% p 是n*2矩阵，每一行是一个样本点，每一列代表对于两个类的隶属度大小
P = posterior(gm,X);
% 标记类别
cluster1 = (idx == 1); 
cluster2 = (idx == 2); 
figure;
% 类别1
scatter(X(cluster1,1),X(cluster1,2),15,P(cluster1,1),'+')
hold on
scatter(X(cluster2,1),X(cluster2,2),15,P(cluster2,1),'o')
hold off
clrmap = jet(80);
colormap(clrmap(9:72,:))
ylabel(colorbar,'属于类别1的后验概率')
title('隶属类别1的后验概率')
legend('cluster-1', 'cluster-2')
set(gcf, 'Position', [100 100 400 320]);
box on

%% 产生75个测试点
Mu = [mu1; mu2]; 
Sigma = cat(3,sigma1,sigma2); 
p = [0.75 0.25]; 
gmTrue = gmdistribution(Mu,Sigma,p);%生成一个高斯混合模型
X0 = random(gmTrue,75);
% 新数据聚类
[idx0,~,P0] = cluster(gm,X0);

figure;
l = ezcontour(@(x,y)pdf(gm,[x y]),[min(X0(:,1)) max(X0(:,1))],...
    [min(X0(:,2)) max(X0(:,2))]);
hold on;
gscatter(X0(:,1),X0(:,2),idx0,'rb','+o');
legend('投影轮廓','Cluster 1','Cluster 2','Location','NorthWest');
title('测试新数据分类效果')
hold off;
set(gcf, 'Position', [100 100 400 320]);
set(l, 'LineWidth', 2);

%% 软聚类的列子  
clear; close all
rng(3)  % For reproducibility
mu1 = [1 2];
sigma1 = [3 .2; .2 2];
mu2 = [-1 -2];
sigma2 = [2 0; 0 1];
% 待聚类的数据
X = [mvnrnd(mu1,sigma1,200); mvnrnd(mu2,sigma2,100)];
 
gm = fitgmdist(X,2);
% 后验概率如果在在[.4, .6]范围内，则人为可以同时
threshold = [0.4 0.6];
% 用posterior函数求样本数据X关于每个成分的后验概率，p是n*k矩阵
P = posterior(gm,X);
% n是样本数，下面对用sort函数对每个类的隶属度大小排序，这里只有两个类
n = size(X,1);
% order返回隶属度值从小到大的对应样本的索引
[~,order] = sort(P(:,1));
figure
subplot(121)
plot(1:n,P(order,1),'r-',1:n,P(order,2),'b-', 'LineWidth', 1.5)
legend({'Cluster 1', 'Cluster 2'})
ylabel('隶属度')
xlabel('样本点')
title('GMM聚类的隶属度曲线')
% 确定同时属于两个类的点
idx = cluster(gm,X);
idxBoth = find(P(:,1)>=threshold(1) & P(:,1)<=threshold(2)); 
% 返回同时属于两个cluster的样本个数
numInBoth = numel(idxBoth)
 
subplot(122)
gscatter(X(:,1),X(:,2),idx,'rb','po',5)
hold on
scatter(X(idxBoth,1),X(idxBoth,2), 30, 'b','filled')
legend({'Cluster 1','Cluster 2','Both Clusters'},'Location','SouthEast', 'FontSize', 8)
title('软聚类')
xlabel('$x$', 'Interpreter', 'Latex')
ylabel('$y$', 'Interpreter', 'Latex')
hold off
set(gcf, 'Position', [100 100 600 260]);

%% 正则化
close all
clear
mu1 = [1 2];
Sigma1 = [1 0; 0 1];
mu2 = [3 4];
Sigma2 = [0.5 0; 0 0.5];
rng(1); % For reproducibility
X1 = [mvnrnd(mu1,Sigma1,100);mvnrnd(mu2,Sigma2,100)];
% 这里第三列和前两列是线性相关的，因此容易出现病态的情况
X = [X1,X1(:,1)+X1(:,2)];
 
rng(1); % 为了重复，fit GMM是初始值的选取是随机的
try
    gm = fitgmdist(X,2)
catch exception
    disp('拟合时出现了问题')
    error = exception.message
end
gm = fitgmdist(X,2,'RegularizationValue',0.1)
% 利用cluster方法聚类
idx = cluster(gm,X);
estimated_label = idx;
ground_truth_label = [2*ones(100,1); ones(100,1)];
k = find(estimated_label ~= ground_truth_label);
% 标记错误分类的点为数字3
idx(k,1) = 3;
cluster1 = idx == 1;
cluster2 = idx == 2;
cluster3 = idx == 3

% 绘图
subplot(121)
scatter3(X(1:100,1),X(1:100,2),X(1:100,3), 15, 'r',  'filled');
hold on
scatter3(X(101:end,1),X(101:end,2),X(101:end,3), 15, 'b',  'filled');
title('原始数据')
legend('Model-0','Model-1', 'Location', 'SouthEast')
% set(gca, 'YLim', [-8 6], 'XLim', [-6 6], 'FontSize', 9);
set(gcf, 'Position', [100 100 400 300]);
hold off

subplot(122)
scatter3(X(cluster1,1),X(cluster1,2),X(cluster1,3), 15, 'b',  'filled');
hold on
scatter3(X(cluster2,1),X(cluster2,2),X(cluster2,3), 15, 'r',  'filled');
scatter3(X(cluster3,1),X(cluster3,2),X(cluster3,3), 20, 'g',  'filled');
title('聚类结果')
legend('Model-0','Model-1', 'error', 'Location', 'SouthEast')
set(gcf, 'Position', [100 100 800 300]);
hold off


%% 拟合GMM时的k选择问题
close all
clear
% 利用pca数据探索
% 加载数据集，这个数据集在UCI，具体信息可以查看UCI网站
load fisheriris
classes = unique(species)
% meas是主要特征数据，4维
% 用pca算法对原始数据降维，score是特征值从大到小排列的结果
[~,score] = pca(meas,'NumComponents',2);
 
% 分别尝试使用不同的k来拟合数据
GMModels = cell(3,1); % 存储三个不同的GMM模型
% 参数声明，最大迭代次数
options = statset('MaxIter',1000);
rng(1); % For reproducibility

% 尝试选择不同的components来拟合模型
for j = 1:3
    GMModels{j} = fitgmdist(score,j,'Options',options);
    fprintf('\n GM Mean for %i Component(s)\n',j)
    Mu = GMModels{j}.mu
end
 
figure
for j = 1:3
    subplot(2,2,j)
    % gscatter可以根据组（也就是label）区分的画出散点图
    % 这里用了2维的信息，可视化
    gscatter(score(:,1),score(:,2),species)
    h = gca;
    hold on
    ezcontour(@(x1,x2)pdf(GMModels{j},[x1 x2]),...
        [h.XLim h.YLim],100)
    title(sprintf('GMM模型 (K = %i) ',j));
    xlabel('第一主轴');
    ylabel('第二主轴');
    if(j ~= 3)
        legend off;
    end
    set(gca, 'FontSize', 10);
    hold off
end
g = legend;
g.Position = [0.7 0.25 0.1 0.1];
set(gcf, 'Position', [100 100 500 400]);

%% 拟合高斯混合模型时，设置初始值
clear
close all
% 加载数据集，并且只使用后两个特征
load fisheriris
X = meas(:,3:4);

% 利用默认的初始值拟合一个GMM,声明K=3
rng(10); % For reproducibility
GMModel1 = fitgmdist(X,3);

% 拟合一个GMM，声明每个训练样本的标签
% y中的数字代表不同的种类
y = ones(size(X,1),1);
y(strcmp(species,'setosa')) = 2;
y(strcmp(species,'virginica')) = 3;
% 拟合模型
GMModel2 = fitgmdist(X,3,'Start',y);

% 拟合一个GMM， 显式的声明初始均值，协方差和混合系数.
Mu = [1 1; 2 2; 3 3];       % 均值
Sigma(:,:,1) = [1 1; 1 2];  % 每个成分的协方差矩阵
Sigma(:,:,2) = 2*[1 1; 1 2];
Sigma(:,:,3) = 3*[1 1; 1 2];
PComponents = [1/2,1/4,1/4];% 混合系数
S = struct('mu',Mu,'Sigma',Sigma,'ComponentProportion',PComponents);
GMModel3 = fitgmdist(X,3,'Start',S);

% 利用gscatter函数绘图
figure
subplot(2,2,1)
% 原始样本
h = gscatter(X(:,1),X(:,2),species,[],'o',4);
haxis = gca;
xlim = haxis.XLim;
ylim = haxis.YLim;
d = (max([xlim ylim])-min([xlim ylim]))/1000;
[X1Grid,X2Grid] = meshgrid(xlim(1):d:xlim(2),ylim(1):d:ylim(2));
hold on
% GMM模型轮廓图
contour(X1Grid,X2Grid,reshape(pdf(GMModel1,[X1Grid(:) X2Grid(:)]),...
    size(X1Grid,1),size(X1Grid,2)),20)
uistack(h,'top')
title('{\bf 随机初始值}');
xlabel('Sepal length');
ylabel('Sepal width');
legend off;
hold off
subplot(2,2,2)
h = gscatter(X(:,1),X(:,2),species,[],'o',4);
hold on
contour(X1Grid,X2Grid,reshape(pdf(GMModel2,[X1Grid(:) X2Grid(:)]),...
    size(X1Grid,1),size(X1Grid,2)),20)
uistack(h,'top')
title('{\bf 根据标签确定初始值}');
xlabel('Sepal length');
ylabel('Sepal width');
legend off
hold off
subplot(2,2,3)
h = gscatter(X(:,1),X(:,2),species,[],'o',4);
hold on
contour(X1Grid,X2Grid,reshape(pdf(GMModel3,[X1Grid(:) X2Grid(:)]),...
    size(X1Grid,1),size(X1Grid,2)),20)
uistack(h,'top')
title('{\bf 给定初始值}');
xlabel('Sepal length');
ylabel('Sepal width');
legend('Location',[0.7,0.25,0.1,0.1]);
hold off

% 显示估计模型的均值.
table(GMModel1.mu,GMModel2.mu,GMModel3.mu,'VariableNames',...
    {'Model1','Model2','Model3'})

%% 产生75个测试点
Mu = [mu1; mu2]; 
Sigma = cat(3,sigma1,sigma2); 
p = [0.75 0.25]; 
 
gmTrue = gmdistribution(Mu,Sigma,p);%生成一个高斯混合模型
X0 = random(gmTrue,75);
%% 聚类
 
[idx0,~,P0] = cluster(gm,X0);
 
figure;
ezcontour(@(x,y)pdf(gm,[x y]),[min(X0(:,1)) max(X0(:,1))],...
    [min(X0(:,2)) max(X0(:,2))]);
hold on;
gscatter(X0(:,1),X0(:,2),idx0,'rb','+o');
legend('Fitted GMM Contour','Cluster 1','Cluster 2','Location','NorthWest');
title('New Data Cluster Assignments')
hold off;

