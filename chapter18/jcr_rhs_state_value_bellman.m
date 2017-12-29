function [v_tmp] = jcr_rhs_state_value_bellman(na,nb,ntrans,V,gamma,Ra,Pa,Rb,Pb,max_num_cars_can_transfer)
max_n_cars = size(V,1)-1; 
% restrict this action: 
ntrans = max(-nb,min(ntrans,na)); 
ntrans = max(-max_num_cars_can_transfer,min(+max_num_cars_can_transfer,ntrans));
% 转移费用
v_tmp   = -2*abs(ntrans);
% 早上执行策略后，出现的状态
na_morn = na-ntrans; 
nb_morn = nb+ntrans; 

for nna=0:max_n_cars, 
  for nnb=0:max_n_cars,
    pa = Pa(na_morn+1,nna+1); 
    pb = Pb(nb_morn+1,nnb+1); 
    % 贝尔曼方程
    v_tmp = v_tmp + pa*pb* ( Ra(na_morn+1) + Rb(nb_morn+1) + gamma*V(nna+1,nnb+1) ); 
  end
end