function [L]=apriori(D,min_sup)
[L,A]=init(D,min_sup); %A为1-频项集  L中为包含1-频仍项集以及对应的支持度
k=1;
C=apriori_gen(A,k); %生成2-组合候选集 
while (size(C,1)~=0) %C如果行数为0，则结束循环
    [M,C]=get_k_itemset(D,C,min_sup);%发生k-频仍项集 M是带支持度  C不带支持度
    if size(M,1)~=0
        L=[L;M];   
    end
    k=k+1;
    C=apriori_gen(C,k);%生成组合候选集 
end
