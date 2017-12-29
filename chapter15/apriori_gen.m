function [C]=apriori_gen(A,k)%发生Ck（实现组内连接及剪枝 ）   
%A表现第k-1次的频仍项集 k表现第k-频仍项集
[m n]=size(A);
C=zeros(0,n);
%组内连接
for i=1:1:m
    for j=i+1:1:m
        flag=1;
        for t=1:1:k-1
            if ~(A(i,t)==A(j,t))
                flag=0;
                break;
            end
        end
        if flag==0 
            break;
        end
        c=A(i,:)|A(j,:);
        flag=isExit(c,A);  %剪枝
        if(flag==1)C=[C;c];
        end
    end
end
