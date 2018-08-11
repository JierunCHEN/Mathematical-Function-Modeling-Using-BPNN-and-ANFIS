%----------------------------------------------
% Date: 14-05-2017
% Discription: Trained a 2D nonlinear system on MATLAB to model signal functions utilizing BP neural networks.
% Author: Jierun CHEN
%----------------------------------------------
close all%关闭打开的figure
clear%清空工作区变量

x=(-10:2:10);
y=(-10:2:10);
z1=sin(x+eps)./(x+eps);  % eps为MATLAB的最小数，
%加上eps是为了避免0/0的错误结果，保证sin(0)/0=1.0
z2=sin(y+eps)./(y+eps); 
z=z1'*z2;
mesh(x,y,z);
title('训练数据精确结果曲面');

x2=(-10:0.5:10);
y2=(-10:0.5:10);
z1_2=sin(x2+eps)./(x2+eps);  
z2_2=sin(y2+eps)./(y2+eps); 
z_2=z1_2'*z2_2;
figure;
mesh(x2,y2,z_2);
title('测试数据精确结果曲面');

%得到训练数据集
a=size(x,2);
b=size(y,2);
trnInput=zeros(2,a*b);
for i=1:a
    for j=1:b
        trnInput(1,(i-1)*a+j)=x(i);
        trnInput(2,(i-1)*a+j)=y(j);
    end
end
trnOutput=reshape(z,1,a*b); 
%得到测试数据集
c=size(x2,2);
d=size(y2,2);
chkInput=zeros(2,c*d);
for i=1:c
    for j=1:d
        chkInput(1,(i-1)*c+j)=x2(i);
        chkInput(2,(i-1)*c+j)=y2(j);
    end
end
chkOutput=reshape(z_2,1,c*d); 

net=newff([minmax(x);minmax(y)],[20 1],{'tansig','purelin'},'trainlm');
net=init(net);              %初始化网络
net.trainParam.show=50;     %每迭代50次显示一次
net.trainParam.lr=0.05;     %学习速率
net.trainParam.epochs=200;  %训练次数
net.trainParam.goal=0.00001;%误差指标

net=train(net,trnInput,trnOutput); 

%训练后BP网络的训练数据输入/输出曲面和输出误差曲面
BPtrnOut=sim(net,trnInput);
BPtrnOut2=reshape(BPtrnOut',a,b);
figure;
mesh(x,y,BPtrnOut2);
title('训练后BP网络的训练数据输入/输出曲面');
figure;
mesh(x,y,BPtrnOut2-z);
title('训练后BP网络的训练数据输出误差曲面');

%训练后BP网络的测试数据输入/输出曲面和输出误差曲面
BPchkOut=sim(net,chkInput);
BPchkOut2=reshape(BPchkOut',c,d);
figure;
mesh(x2,y2,BPchkOut2);
title('训练后BP网络的测试数据输入/输出曲面');
figure;
mesh(x2,y2,BPchkOut2-z_2);
title('训练后BP网络的测试数据输出误差曲面');
