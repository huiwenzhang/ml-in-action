
% 这个script将展示如何利用SARSA算法求解悬崖行走问题
% Note：这本来可以写成一个脚本文件，但是为了在一个函数中定义所有的子函数，写成函数的形式
% （matlab脚本文件中无法定义子函数）
% 初始化参数，通用参数
close all
clear
alpha = 1e-1  %学习步长
row = 4; col = 12   %网格大小
CF = ones(row, col); CF(row, 2:(col-1)) = 0 %网格中为0的地方表示悬崖
s_start = [4, 1]; %初始状态
s_end = [4, 12];    %目标
max_epoch = 500;  %最多学习多少轮，一个episode是一轮

% SARSA中的参数
gamma = 1;  %折扣系数
epsilon = .1;   %epsilon-greedy策略的概率阈值
nStates = row*col;  %所有的状态数
nActions = 4;   %每个状态的行为

Q = zeros(nStates, nActions);   %行为值函数矩阵，SARSA的更新目标
ret_epi = zeros(1, max_epoch);  %存储每一个episode的累积回报R
n_qlearn = zeros(nStates, nActions); %存储每个（s,a）访问的次数
steps_epi = zeros(1, max_epoch);    %存储每个episode中经历的步数，越小说明学习越快

% 进行每一轮循环
for ei = 1:max_epoch
    q_finish = 0; %标志sarsa是否结束
    st = s_start;

    % 初始化状态，开始算法的step2
    % sub2ind函数把一个多维的索引转换成一个一维的索引值，这样每个网格坐标被映射成一个唯一的整数值
    st_index = sub2ind([row, col], s_start(1), s_start(2));

    % 选择一个行为，对应算法step2后半句
    [value, action] = max(Q(st_index, :))   %这里分别用1,2,3,4代表上下左右4个行为

    % 以epsilon的概率选择一个随机策略
    if( rand<epsilon )       
        tmp=randperm(nActions); action=tmp(1); %产生一个随机策略
    end
    
    % 开始一个episode，对应算法step3
    R = 0;
    while(1)
        %根据当前状态和行为，返回下一个(s',a')和回报， 算法s3-1
        [reward, next_state]  = transition(st, action, CF, s_start,s_end);
        R = R + reward;
        next_ind = sub2ind( [row, col], next_state(1), next_state(2));
        % 如果下一个状态不是终止态，则执行
        if (~q_finish)
            steps_epi(1, ei) = steps_epi(1, ei) +1;
            % 选择下一个状态的行为，算法s3-2
            [value, next_action] = max(Q(next_ind, :));
            if( rand<epsilon )         
                tmp=randperm(nActions); next_action=tmp(1); 
            end
            n_qlearn(st_index,action) = n_qlearn(st_index,action)+1; %状态的出现次数
            if( ~( (next_state(1)==s_end(1)) && (next_state(2)==s_end(2)) ) ) % 下一个状态不是终止态
                Q(st_index,action) = Q(st_index,action) + alpha*( reward + gamma*max(Q(next_ind,:)) - Q(st_index,action) ); %值函数更新
            else                                                  % stp1 IS the terminal state ... no Q_sarsa(s';a') term in the sarsa update
                Q(st_index,action) = Q(st_index,action) + alpha*( reward - Q(st_index,action) );
                q_finish=1;
            end
            % 更新状态，对应算法s3-4
            st = next_state; action = next_action; st_index = next_ind;
        end
        if (q_finish)
            break;
        end
    end     %结束一个episode的循环
    
    ret_epi(1,ei) = R;
          
end

% 获得策略
sideII=4; sideJJ=12;
% 初始化pol_pi_sarsa表示策略，V_sarsa是值函数，n_g_sarsa 是当前状态采取最优策略的次数
pol_pi_qlearn  = zeros(sideII,sideJJ); V_sarsa  = zeros(sideII,sideJJ); n_g_sarsa  = zeros(sideII,sideJJ); 
for ii=1:sideII,
  for jj=1:sideJJ,
    sti = sub2ind( [sideII,sideJJ], ii, jj ); 
    [V_sarsa(ii,jj),pol_pi_qlearn(ii,jj)] = max( Q(sti,:) ); 
    n_g_sarsa(ii,jj) = n_qlearn(sti,pol_pi_qlearn(ii,jj));
  end
end

% 绘图
plot_cw_policy(pol_pi_qlearn,CF,s_start,s_end);
title( 'Q学习算法策略' ); 
% fn = sprintf('cw_sarsa_policy_nE_%d',MAX_N_EPISODES); if( save_figs ) saveas( gcf, fn, 'png' ); end 

figure('Position', [100 100 400 200]); 
imagesc( V_sarsa ); colormap(flipud(jet)); colorbar; 
title( 'Q学习算法状态行为值' ); 
set(gca, 'Ytick', [1 2 3 4 ], 'Xtick', [1:12], 'FontSize', 9);
% fn = sprintf('cw_sarsa_state_value_fn_nE_%d',MAX_N_EPISODES); if( save_figs ) saveas( gcf, fn, 'png' ); end

figure('Position', [100 100 400 200]); 
imagesc( n_g_sarsa ); colorbar; 
title( 'Q学习:最优策略的步数' ); 
set(gca, 'Ytick', [1 2 3 4 ], 'Xtick', [1:12], 'FontSize', 9);

% 观察学习过程
figure('Position', [100 100 600 250]); 
subplot(121)
plot(1:max_epoch, ret_epi, 'b', 'LineWidth', 1);
title('每个episode的累积回报(Q学习)');
xlabel('episode');
ylabel('回报值');
set(gca, 'FontSize', 9);
axis( [-50 600 -2500 100]);
subplot(122)
plot(1:max_epoch, steps_epi, '-b', 'LineWidth', 1, 'Marker', 'o', 'MarkerSize', 2);
title('平均每个episode用的步数(Q学习)');
xlabel('episode');
ylabel('步数');
set(gca, 'FontSize', 9);
axis( [-50 600 -100 1000]);