%%Apriori的Matlab算法实例主程序
clc
clear
close
a=[ 1	1	0	0	0	0;
1	0	0	1	1	0;
0	0	0	1	0	1;
1	1	1	1	0	1;
1	0	0	0	1	1;
1	0	1	1	0	1;
];
apriori(a,3)