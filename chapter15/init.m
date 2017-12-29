function [L,A]=init(D,min_sup) %D表现数据集  min_sup 最小支持度
[m,n]=size(D);
A=eye(n,n);
B=(sum(D))';
i=1;
while(i<=n)
    if B(i)<min_sup
        B(i)=[];
        A(i,:)=[];
        n=n-1;
    else
        i=i+1;
    end
end
L=[A,B];
