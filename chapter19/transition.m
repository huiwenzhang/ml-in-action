
function [reward, next_state] = transition(st, act, CF, s_start, s_end)
% 函数用于计算当前转移到下一个状态，返回（s',a')和r
[row, col] = size(CF);
ii = st(1); jj = st(2);

switch act
    case 1,
        %
        % action = UP
        %
        next_state = [ii-1,jj];
    case 2,
        %
        % action = DOWN
        %
        next_state = [ii+1,jj];
    case 3,
        %
        % action = RIGHT
        %
        next_state = [ii,jj+1];
    case 4
        %
        % action = LEFT
        %
        next_state = [ii,jj-1];
    otherwise
        error(sprintf('未定义的行为 = %d',act));
end

% 边界处理
if( next_state(1)<1      ) next_state(1)=1;      end
if( next_state(1)>row ) next_state(1)=row; end
if( next_state(2)<1      ) next_state(2)=1;      end
if( next_state(2)>col ) next_state(2)=col; end

% 回报计算

if( (ii==s_end(1)) && (jj==s_end(2)) )  % 结束
  reward = 0;
elseif( CF(next_state(1),next_state(2))==0 )        % 在悬崖区域
  reward  = -100;
  next_state = s_start;
else                                   
  reward = -1;
end
end
