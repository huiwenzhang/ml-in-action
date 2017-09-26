%%通过while，if 语句实现
a=[1,2,3;4,5,6;7,8,9];
i=1;%行数为1
while (i<=3)
    j=1;%列数为1
    while (j<=3)
        if (a(i,j)==5||a(i,j)==6) %判别条件
            a(i,j)=0;
        end 
        j=j+1;
    end
    i=i+1;
end
a %对a进行输出