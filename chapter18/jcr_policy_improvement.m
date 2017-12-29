function [pol_pi,policyStable] = jcr_policy_improvement(pol_pi,V,gamma,Ra,Pa,Rb,Pb,max_num_cars_can_transfer)
if( nargin < 3 ) gamma = 0.9; end
% 最大车辆数: 
max_n_cars = size(V,1)-1;
% 总共的状态数，包括0的情况 
nStates = (max_n_cars+1)^2; 
% assume the policy is stable (until we learn otherwise below): 
policyStable = 1; tm = NaN; 

% 对于S中的每个状态，循环:
fprintf('开始策略提升...\n'); 
for si=1:nStates, 
    % 得到每个场所的车辆数: 
    [na1,nb1] = ind2sub( [ max_n_cars+1, max_n_cars+1 ], si ); 
    na = na1-1; nb = nb1-1; % (zeros based) 
    
    % 原始的策略: 
    b = pol_pi(na1,nb1);

    % 当前的行为空间，受限于当地的车辆数和最大的可移动的车辆数
    posA = min([na,max_num_cars_can_transfer]); 
    posB = min([nb,max_num_cars_can_transfer]); 
    % posActionsInState表示从A转移到B的所有可能的情况，也就是我们的行为空间
    posActionsInState = [ -posB:posA ]; npa = length(posActionsInState); 
    Q = -Inf*ones(1,npa);   % 行为值函数
    tic; 
    for ti = 1:npa,
      ntrans = posActionsInState(ti);
      % 计算所有行为的期望回报
      Q(ti) = jcr_rhs_state_value_bellman(na,nb,ntrans,V,gamma,Ra,Pa,Rb,Pb,max_num_cars_can_transfer);
    end % end ntrans 
    tm=toc; 
    
    % 更新策略
    [dum,imax] = max( Q );  % 得到最佳策略的索引和对应的Q值
    maxPosAct  = posActionsInState(imax);   % 最佳行为
    if( maxPosAct ~= b )      % 检查原始策略是否最优 ...
      policyStable = 0; 
      pol_pi(na1,nb1) = maxPosAct; % <- 更新策略
    end
end % end state loop 
fprintf('结束策略提升...\n'); 