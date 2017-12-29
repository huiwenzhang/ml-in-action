function [L C]=get_k_itemset(D,C,min_sup)%D为数据集  C为第K次剪枝后的候选集 取得第k次的频仍项集
m=size(C,1);
M=zeros(m,1);
t=size(D,1);
i=1;
while i<=m
    C(i,:);
    H=ones(t,1);
    ind=find(C(i,:)==1);
    n=size(ind,2);
    for j=1:1:n
        D(:,ind(j));
        H=H&D(:,ind(j));
    end
        x=sum(H');
        if x<min_sup
            C(i,:)=[];
            M(i)=[];
            m=m-1;
        else
            M(i)=x;
            i=i+1;
        end
end
L=[C M];
