%% 拟合一个GMM模型
%% 
% 产生两个二维的服从高斯分
close all
clear
mu1 = [1 2];
Sigma1 = [2 0; 0 0.5];
mu2 = [-3 -5];
Sigma2 = [1 0;0 1];
rng(1); % For reproducibility
X = [mvnrnd(mu1,Sigma1,1000);mvnrnd(mu2,Sigma2,1000)];% 合成的数据
%%
% 模型拟合，声明2个成分
gm = fitgmdist(X,2);
%%
% 画出拟合的高斯模型
figure
y = [zeros(1000,1);ones(1000,1)];
h = gscatter(X(:,1),X(:,2),y);
hold on
ezcontour(@(x1,x2)pdf(gm,[x1 x2]),get(gca,{'XLim','YLim'}))
title('{\bf Scatter Plot and Fitted Gaussian Mixture Contours}')
legend(h,'Model 0','Model1')
hold off

%% 打印参数
properties(gm)

%%
mu1 = [1 2];
Sigma1 = [1 0; 0 1];
mu2 = [3 4];
Sigma2 = [0.5 0; 0 0.5];
rng(1); % For reproducibility
X1 = [mvnrnd(mu1,Sigma1,100);mvnrnd(mu2,Sigma2,100)];
X = [X1,X1(:,1)+X1(:,2)];% 这里第三列和前两列是线性相关的，因此容易出现病态的情况

rng(1); % 为了重复，fit GMM是初始值的选取是随机的
try
    GMModel = fitgmdist(X,2)
catch exception
    disp('拟合时出现了问题')
    error = exception.message
end

rng(1); % Reset seed for common start values
GMModel = fitgmdist(X,2,'RegularizationValue',0.1)

%% 拟合GMM时的k选择问题
% 利用pca数据探索

% 加载数据集，这个数据集在UCI，具体信息可以查看UCI网站
load fisheriris
classes = unique(species)
% meas是主要特征数据，4维
% 用pca算法对原始数据降维，score是特征从大到小排列的结果
[~,score] = pca(meas,'NumComponents',2);

% 分别尝试使用不同的k来拟合数据
GMModels = cell(3,1); % Preallocation
options = statset('MaxIter',1000);
rng(1); % For reproducibility

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
    title(sprintf('GM Model - %i Component(s)',j));
    xlabel('1st principal component');
    ylabel('2nd principal component');
    if(j ~= 3)
        legend off;
    end
    hold off
end
g = legend;
g.Position = [0.7 0.25 0.1 0.1];