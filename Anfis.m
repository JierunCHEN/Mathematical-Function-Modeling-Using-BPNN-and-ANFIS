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
trnData=zeros(a*b,3);
for i=1:a
    for j=1:b
        trnData((i-1)*a+j,1)=x(i);
        trnData((i-1)*a+j,2)=y(j);
        trnData((i-1)*a+j,3)=z(i,j);
    end
end
%得到测试数据集
c=size(x2,2);
d=size(y2,2);
chkData=zeros(c*d,3);
for i=1:c
    for j=1:d
        chkData((i-1)*c+j,1)=x2(i);
        chkData((i-1)*c+j,2)=y2(j);
        chkData((i-1)*c+j,3)=z_2(i,j);
    end
end

numMFs=7;%x和y都采用7条隶属度函数
mfType='gaussmf';%采用高斯型隶属度函数
epoch_n=100;%训练的次数
in_fismat=genfis1(trnData,numMFs,mfType);
[fismat,trnErr,ss]=anfis(trnData,in_fismat,epoch_n);

%绘制训练过程均方根误差的变化情况，如果训练数据的误差减小，模型才是有效的
epoch=1:epoch_n;
figure;
plot(epoch,trnErr)
title('训练数据误差');

%训练后系统的训练数据输入/输出曲面和输出误差曲面
trnOut=evalfis(trnData(:,[1,2]),fismat);
trnOut2=reshape(trnOut',a,b);
figure;
mesh(x,y,trnOut2);
title('训练后系统的训练数据输入/输出曲面');
figure;
mesh(x,y,trnOut2-z);
title('训练后系统的训练数据输出误差曲面');

%训练后系统的测试数据输入/输出曲面和输出误差曲面
chkOut=evalfis(chkData(:,[1,2]),fismat);
chkOut2=reshape(chkOut',c,d);
figure;
mesh(x2,y2,chkOut2);
title('训练后系统的测试数据输入/输出曲面');
figure;
mesh(x2,y2,chkOut2-z_2);
title('训练后系统的测试数据输出误差曲面');








