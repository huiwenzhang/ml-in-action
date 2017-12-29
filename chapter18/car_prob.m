
%%策略迭代方法求解租车问题
clc; clear;
close all; 
% 参数设置
max_n_cars = 20;        % 最大租车数: 
gamma = 0.9;            % 折扣系数
transfer_car = 5;       % 每天最大的转移车辆数
lambda_A_return = 3;    % A公司平均每天归还的车辆数
lambda_A_rental = 3;    % A公司每天车辆的平均需求量
lambda_B_return = 2;    % B公司平均每天归还的车辆数
lambda_B_rental = 4;    % B公司每天车辆的平均需求量

%计算回报和转移概率 
[Ra,Pa] = cmpt_P_and_R(lambda_A_rental,lambda_A_return,max_n_cars,transfer_car);
[Rb,Pb] = cmpt_P_and_R(lambda_B_rental,lambda_B_return,max_n_cars,transfer_car);

% 初始化值函数 
V = zeros(max_n_cars+1,max_n_cars+1); 
% 初始策略
pol_pi = zeros(max_n_cars+1,max_n_cars+1); 
policyStable = 0; iterNum = 0; 
% 开始策略迭代，策略更新稳定后，停止运行
while( ~policyStable )
  % plot the current policy:
  figure('Position', [200 100+200*iterNum 580 200]);    % 如果迭代次数过多，应调整图的位置
  subplot(1,2,1)
  imagesc( 0:max_n_cars, 0:max_n_cars, pol_pi ); colorbar; xlabel( 'num at B' ); ylabel( 'num at A' );
  title( ['当前策略 iter=', num2str(iterNum)] ); axis xy; drawnow;
  set(gca, 'FontSize', 9);

  % 估计当前策略下的状态值函数 
  V = jcr_policy_evaluation(V,pol_pi,gamma,Ra,Pa,Rb,Pb,transfer_car);
  subplot(122)
  imagesc( 0:max_n_cars, 0:max_n_cars, V ); colorbar; 
  xlabel( 'num at B' ); ylabel( 'num at A' ); 
  title( ['当前状态值函数 iter=', num2str(iterNum)] ); axis xy; drawnow; 
  set(gca, 'FontSize', 9);
 
  % 利用最新的值函数提升策略 
  [pol_pi,policyStable] = jcr_policy_improvement(pol_pi,V,gamma,Ra,Pa,Rb,Pb,transfer_car);
  % 下一次迭代
  iterNum=iterNum+1; 
end






