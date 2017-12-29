% Q更新的部分实现
for ei = 1:max_episodes
    q_finish = 0;
    % 设置初始状态，以及初始状态对应的一维索引号
    st = s_start; sti_qlearn = sub2ind( [sideII,sideJJ], st(1), st(2) ); 
    % 根据初始状态，产生一个行为
    [value,action] = max(Q_qlearn(sti_qlearn,:));  
    if( rand<epsilon )         % explore ... with a random action
        tmp=randperm(nActions); action=tmp(1);
    end
    
    % 开始一个episode
    R = 0;
    while(1)
        %根据当前状态和行为，返回下一个(s',a')和回报， 算法s3-1
        [reward, next_state]  = transition(st, action, CF, s_start,s_end);
        R = R + reward;
        nextindex = sub2ind( [sideII,sideJJ], next_state(1), next_state(2) );
        
        if ~q_finish
            steps_epi(1, ei) = steps_epi(1, ei) +1;
            [value, next_action] = max(Q(nextindex, :));
            if( rand<epsilon )         
                tmp=randperm(nActions); next_action=tmp(1); 
            end
            if( ~( (next_state(1)==s_end(1)) && (next_state(2)==s_end(2)) ) ) % 下一个状态不是终止态
                Q(st,action) = Q(st,action) + alpha*( reward + gamma*max(Q(nextindex,:)) - Q(st,action) ); %值函数更新,算法s3-3
            else
                Q(st,action) = Q(st,action) + alpha*( reward - Q(st,action) );
                q_finish=1;
            end
            % 更新状态，对应算法s3-4
            st = next_state; action = next_action; st_index = nextindex;
        end
        if (sarsa_finish)
            break;
        end
    end     %结束一个episode的循环
    ret_epi(ei) = R; 
end        