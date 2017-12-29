function [R,P] = cmpt_P_and_R(lambdaRequests,lambdaReturns,max_n_cars,max_num_cars_can_transfer)
% 用于计算回报和转移概率
if( nargin==0 )
  lambdaRequests=4; 
  lambdaReturns=2; 
  max_n_cars=20; 
  max_n_cars_can_transfer=5; 
end

PLOT_FIGS=0;        % 是否画图
% 每个公司当天早上可能的车辆数目 
nCM = 0:(max_n_cars+max_num_cars_can_transfer);
% 返回平均回报
R = zeros(1,length(nCM));
% 每个地方的收益和当地的车辆数有关，而每个地方早上的车辆数不超过25辆，26个状态，对于每个状态有一个期望回报
for n = nCM,
    tmp = 0.0;
     % 当地车辆的需求数实际上可以是任何自然数，但是当需求偏离平均需求太大时，概率基本为0，因此这里取到30
    for nreq = 0:(10*lambdaRequests),
      for nret = 0:(10*lambdaReturns), % <- a value where the probability of returns is very small.
          % 计算当地每天可以租出去车辆的概率
        tmp = tmp + 10*min(n+nret,nreq)*poisspdf( nreq, lambdaRequests )*poisspdf( nret, lambdaReturns );
      end
    end
    R(n+1) = tmp;
end


if( PLOT_FIGS ) 
  figure; plot( nCM, R, 'x-' ); grid on; axis tight; 
  xlabel(''); ylabel(''); drawnow; 
end

% P表示转移概率， 
P = zeros(length(nCM),max_n_cars+1); 
for nreq = 0:(10*lambdaRequests), 
  reqP = poisspdf( nreq, lambdaRequests ); 
  % 所有归还车辆的可能情况:
  for nret = 0:(10*lambdaReturns), 
    retP = poisspdf( nret, lambdaReturns ); 
    % 每日早晨可能出现车辆数的情况: 
    for n = nCM,
      sat_requests = min(n,nreq); 
      new_n = max( 0, min(max_n_cars,n+nret-sat_requests) );
      P(n+1,new_n+1) = P(n+1,new_n+1) + reqP*retP;
    end
  end
end
if( PLOT_FIGS ) 
  figure; imagesc( 0:max_n_cars, nCM, P ); colorbar; 
  xlabel('num at the end of the day'); ylabel('num in morning'); axis xy; drawnow; 
end





