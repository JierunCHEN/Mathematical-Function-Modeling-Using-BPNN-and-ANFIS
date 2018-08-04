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
trnData=zeros(a*b,3);
for i=1:a
    for j=1:b
        trnData((i-1)*a+j,1)=x(i);
        trnData((i-1)*a+j,2)=y(j);
        trnData((i-1)*a+j,3)=z(i,j);
    end
end
%�õ��������ݼ�
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

numMFs=7;%x��y������7�������Ⱥ���
mfType='gaussmf';%���ø�˹�������Ⱥ���
epoch_n=100;%ѵ���Ĵ���
in_fismat=genfis1(trnData,numMFs,mfType);
[fismat,trnErr,ss]=anfis(trnData,in_fismat,epoch_n);

%����ѵ�����̾��������ı仯��������ѵ�����ݵ�����С��ģ�Ͳ�����Ч��
epoch=1:epoch_n;
figure;
plot(epoch,trnErr)
title('ѵ���������');

%ѵ����ϵͳ��ѵ����������/������������������
trnOut=evalfis(trnData(:,[1,2]),fismat);
trnOut2=reshape(trnOut',a,b);
figure;
mesh(x,y,trnOut2);
title('ѵ����ϵͳ��ѵ����������/�������');
figure;
mesh(x,y,trnOut2-z);
title('ѵ����ϵͳ��ѵ����������������');

%ѵ����ϵͳ�Ĳ�����������/������������������
chkOut=evalfis(chkData(:,[1,2]),fismat);
chkOut2=reshape(chkOut',c,d);
figure;
mesh(x2,y2,chkOut2);
title('ѵ����ϵͳ�Ĳ�����������/�������');
figure;
mesh(x2,y2,chkOut2-z_2);
title('ѵ����ϵͳ�Ĳ�����������������');








