function [V] = jcr_policy_evaluation(V,pol_pi,gamma,Ra,Pa,Rb,Pb,max_num_cars_can_transfer)

if( nargin < 3 ) gamma = 0.9; end
  
% 每个地方的最大车辆数: 
max_n_cars = size(V,1)-1;
% 所有的状态，拉伸成一维的情况: 
nStates = (max_n_cars+1)^2; 
% 收敛参数设定，主要是迭代误差和迭代次数
MAX_N_ITERS = 100; iterCnt = 0; 
CONV_TOL    = 1e-6;  delta = +inf;  tm = NaN; 

fprintf('beginning policy evaluation ... \n'); 
% 如果两次迭代值函数的插值大于阈值且迭代次数没有超过上限，则一直迭代
while( (delta > CONV_TOL) && (iterCnt <= MAX_N_ITERS) ) 
  delta = 0; 
  % 计算每一个状态s \in {S}单步的更新值:
  for si=1:nStates, 
    % ind2sub函数将一维的索引值转化为二维的，并返回对应的二维索引下标，这里就是返回a,b的车辆数: 
    [na1,nb1] = ind2sub( [ max_n_cars+1, max_n_cars+1 ], si ); 
    na = na1-1; nb = nb1-1; % (从0开始) 
    % 更新前的值 
    v = V(na1,nb1); 
    % 根据当前策略和状态确定转移的车辆数（即行为） 
    ntrans = pol_pi(na1,nb1); 
    % 根据贝尔曼方程计算当前的更新值，关键的一步
    V(na1,nb1) = jcr_rhs_state_value_bellman(na,nb,ntrans,V,gamma,Ra,Pa,Rb,Pb,max_num_cars_can_transfer);
    delta = max( [ delta, abs( v - V(na1,nb1) ) ] ); 
  end % end state loop 
    
  iterCnt=iterCnt+1; 
  % 打印当前的step和相应的误差delta 
  if( 1 && mod(iterCnt,1)==0 )
    fprintf( 'iterCnt=%5d; delta=%15.8f\n', iterCnt, delta );  
  end
end  
fprintf('ended policy evaluation ... \n'); 