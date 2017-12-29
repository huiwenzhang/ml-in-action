
clear
close all
writerObj=VideoWriter('em.avi', 'Uncompressed AVI');  %// 定义一个视频文件用来存动画  
% writerObj.LosslessCompression = true;
writerObj.FrameRate = 10;
open(writerObj);                    %// 打开该视频文件  
%-----------------------产生数据-------------------------------------------
mu1 = [1 2];
sigma1 = [3 .2; .2 2];
mu2 = [-1 -2];
sigma2 = [2 0; 0 1];
%2个高斯的数据样本
X = [mvnrnd(mu1,sigma1,200); mvnrnd(mu2,sigma2,100)]';  % 拟合的数据
[nbVar, nbData] = size(X);   % 数据的维度和个数

% 定义一个结构体用于保存模型参数和配置
model.nbStates = 2; % 隐变量有三个取值，对于GMM来说就是3个成分
model.nbVar = nbVar;    % 数据的维度
model.nbData = nbData;
diagRegularizationFactor = 1E-4; % 正则化项，可选参数

%-----------------------参数初始化-------------------------------------------
% 把数据按照大小分成nbStates个段，然后用每段范围内的数据计算初始值
% 把数据按照某个维度打乱排序
[B, I] = sort(X(1,:));   % 按照第一行排序返回索引
Data = X(:, I); % 排序后的数据
Sep = linspace(min(Data(1,:)), max(Data(1,:)), model.nbStates+1);
% 分别对每个段初始化
for i=1:model.nbStates
	idtmp = find( Data(1,:)>=Sep(i) & Data(1,:)<Sep(i+1));  % 返回数据段的索引
	model.Priors(i) = length(idtmp);    % 初始先验为数据点的比重
	model.Mu(:,i) = mean(Data(:,idtmp)');   % 初始化均值
	model.Sigma(:,:,i) = cov(Data(:,idtmp)');   % 初始化协方差矩阵
	%正则化防止协方差矩阵行列式为0，出现计算的不稳定性
	model.Sigma(:,:,i) = model.Sigma(:,:,i) + eye(nbVar)*diagRegularizationFactor;
end
model.Priors = model.Priors / sum(model.Priors);

% EM算法的参数
nbMinSteps = 5; %Minimum number of iterations allowed
nbMaxSteps = 100; %最大迭代次数
err_ll = 1E-6; % 似然函数的变化率，当变化小于这个阈值时，说明收敛了


%-----------------------EM迭代-------------------------------------------
% 主循坏，迭代开始
for nbIter=1:nbMaxSteps
	fprintf('.');
	
	%E-step，计算后验概率，L表示每个样本点取z=1,2...的概率
    L = zeros(model.nbStates,size(Data,2)); % 初始化矩阵，用于存放w
    for i=1:model.nbStates  % 对于每个z
        L(i,:) = model.Priors(i) * gaussPDF(Data, model.Mu(:,i), model.Sigma(:,:,i));
    end
    % sum(A, 1)按列求和，返回行向量， repmat(A, m, n)：在声明的维度上复制A
    GAMMA = L ./ repmat(sum(L,1)+realmin, model.nbStates, 1);   % 后验概率
	GAMMA2 = GAMMA ./ repmat(sum(GAMMA,2),1,nbData);   % w_i/sum(w_i)
	
	%M-step
	for i=1:model.nbStates
		% 更新phi，先验
		model.Priors(i) = sum(GAMMA(i,:)) / nbData;
		
		% 更新均值
		model.Mu(:,i) = Data * GAMMA2(i,:)';
		
		% 更新协方差矩阵
		DataTmp = Data - repmat(model.Mu(:,i),1,nbData);
		model.Sigma(:,:,i) = DataTmp * diag(GAMMA2(i,:)) * DataTmp' + eye(size(Data,1)) * diagRegularizationFactor;
    end
	
    % 显示迭代过程
    if mod(nbIter , 4) == 0
        plot_em(nbIter, X', model.Mu, model.Sigma);
        pause(2);   % 暂停2秒
    end
    frame = getframe;            %// 把图像存入视频文件中
    writeVideo(writerObj,frame); %// 将帧写入视频
    
	% 计算似然函数值
	LL(nbIter) = sum(log(sum(L,1))) / nbData;
	%Stop the algorithm if EM converged (small change of LL)
	if nbIter>nbMinSteps
		if LL(nbIter)-LL(nbIter-1)<err_ll || nbIter==nbMaxSteps-1
			disp(['EM算法在 ' num2str(nbIter) ' 次迭代后收敛.']);
			break;
		end
	end
end
if nbIter == nbMaxSteps-1
    disp(['达到了最大迭代次数，考虑增加最大迭代次数的设置...']);
end

% -------------------------------和内置的GMM算法比较----------------------------
gm = fitgmdist(Data', 2);
plot_em(nbIter, X', model.Mu, model.Sigma);

% plot(Data(1,:),Data(2,:),'.','markersize',8,'color',[.7 .7 .7]);hold on;
hold on
plotGMM(gm.mu, gm.Sigma, [0 0.8 0], .5);
frame = getframe;            %// 把图像存入视频文件中  
writeVideo(writerObj,frame); %// 将帧写入视频  
close(writerObj); %// 关闭视频文件句柄  
