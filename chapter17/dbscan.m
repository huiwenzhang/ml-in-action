function class = dbscan(data, Minpts, varargin)
% 利用dbscan算法对数据x聚类
% 输入:
%     data: m*n, m objects and n features;
%     Eps: radius;
%     Minpts: values used for define core points
% 输出:   
%     cluter: cluster labels for non-noiose data points
  
% 定义参数Eps和MinPts  
MinPts = Minpts;  
if nargin > 2
    Eps = varargin{1};
else
    % epsilon函数用于计算领域的半径
    Eps = epsilon(data, Minpts);
end

[m,n] = size(data);%得到数据的大小  
x = [(1:m)' data];  
[m,n] = size(x);%重新计算数据集的大小  
types = zeros(1,m);%用于区分核心点1，边界点0和噪音点-1  
dealed = zeros(m,1);%用于判断该点是否处理过,0表示未处理过  
dis = calDistance(x(:,2:n));  
number = 1;%用于标记类  
  
% 对每一个点进行处理  
for i = 1:m  
    %找到未处理的点  
    if dealed(i) == 0  
        xTemp = x(i,:);  
        D = dis(i,:);%取得第i个点到其他所有点的距离  
        ind = find(D<=Eps);%找到半径Eps内的所有点 
        % 区分点的类型  
        %边界点  
        if length(ind) > 1 && length(ind) < MinPts+1  
            types(i) = 0;  
            class(i) = 0;  
        end  
        %噪音点  
        if length(ind) == 1  %和自己的距离
            types(i) = -1;  
            class(i) = -1;  
            dealed(i) = 1;  
        end  
        %核心点(此处是关键步骤)  
        if length(ind) >= MinPts+1  
            types(xTemp(1,1)) = 1;  
            class(ind) = number;  
              
            % 判断核心点是否密度可达  
            while ~isempty(ind)  
                yTemp = x(ind(1),:);  
                dealed(ind(1)) = 1;  
                ind(1) = [];  
                D = dis(yTemp(1,1),:);%找到与ind(1)之间的距离  
                ind_1 = find(D<=Eps);  
                  
                if length(ind_1)>1%处理非噪音点  
                    class(ind_1) = number;  
                    if length(ind_1) >= MinPts+1  
                        types(yTemp(1,1)) = 1;  
                    else  
                        types(yTemp(1,1)) = 0;  
                    end  
                      
                    for j=1:length(ind_1)  
                       if dealed(ind_1(j)) == 0  
                          dealed(ind_1(j)) = 1;  
                          ind=[ind ind_1(j)];     
                          class(ind_1(j))=number;  
                       end                      
                   end  
                end  
            end  
            number = number + 1;  
        end  
    end  
end  
  
% 最后处理所有未分类的点为噪音点  
ind_2 = find(class==0);  
class(ind_2) = -1;  
types(ind_2) = -1;  
  
% 画出最终的聚类图  
% 原始类别图
figure('Position',[20 20 500 200]);
subplot(121);
scatter(data(1:200,1),data(1:200,2),15,'ro','filled');
hold on
scatter(data(201:end,1),data(201:end,2),15,'bo','filled')
title('真实的聚类结果');

subplot(122);
hold on
for i = 1:m  
    if class(i) == -1  
        plot(data(i,1),data(i,2),'.r');  
    elseif class(i) == 1  
        if types(i) == 1  
            plot(data(i,1),data(i,2),'+b');  
        else  
            plot(data(i,1),data(i,2),'.b');  
        end  
    elseif class(i) == 2  
        if types(i) == 1  
            plot(data(i,1),data(i,2),'+g');  
        else  
            plot(data(i,1),data(i,2),'.g');  
        end  
    elseif class(i) == 3  
        if types(i) == 1  
            plot(data(i,1),data(i,2),'+c');  
        else  
            plot(data(i,1),data(i,2),'.c');  
        end  
    else  
        if types(i) == 1  
            plot(data(i,1),data(i,2),'+k');  
        else  
            plot(data(i,1),data(i,2),'.k');  
        end  
    end  
end  
hold off  
title(sprintf('DBSCAN算法(MinPts=%d)', Minpts));

