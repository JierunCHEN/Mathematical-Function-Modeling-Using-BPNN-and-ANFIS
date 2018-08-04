close all%�رմ򿪵�figure
clear%��չ���������

x=(-10:2:10);
y=(-10:2:10);
z1=sin(x+eps)./(x+eps);  % epsΪMATLAB����С����
%����eps��Ϊ�˱���0/0�Ĵ���������֤sin(0)/0=1.0
z2=sin(y+eps)./(y+eps); 
z=z1'*z2;
mesh(x,y,z);
title('ѵ�����ݾ�ȷ�������');

x2=(-10:0.5:10);
y2=(-10:0.5:10);
z1_2=sin(x2+eps)./(x2+eps);  
z2_2=sin(y2+eps)./(y2+eps); 
z_2=z1_2'*z2_2;
figure;
mesh(x2,y2,z_2);
title('�������ݾ�ȷ�������');

%�õ�ѵ�����ݼ�
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
%�õ��������ݼ�
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
net=init(net);              %��ʼ������
net.trainParam.show=50;     %ÿ����50����ʾһ��
net.trainParam.lr=0.05;     %ѧϰ����
net.trainParam.epochs=200;  %ѵ������
net.trainParam.goal=0.00001;%���ָ��

net=train(net,trnInput,trnOutput); 

%ѵ����BP�����ѵ����������/������������������
BPtrnOut=sim(net,trnInput);
BPtrnOut2=reshape(BPtrnOut',a,b);
figure;
mesh(x,y,BPtrnOut2);
title('ѵ����BP�����ѵ����������/�������');
figure;
mesh(x,y,BPtrnOut2-z);
title('ѵ����BP�����ѵ����������������');

%ѵ����BP����Ĳ�����������/������������������
BPchkOut=sim(net,chkInput);
BPchkOut2=reshape(BPchkOut',c,d);
figure;
mesh(x2,y2,BPchkOut2);
title('ѵ����BP����Ĳ�����������/�������');
figure;
mesh(x2,y2,BPchkOut2-z_2);
title('ѵ����BP����Ĳ�����������������');
