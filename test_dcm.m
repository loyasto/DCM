clear;
clc;
imu_interval_s=0.02;
%ʱ����Ϊ0.02��
%��ʼ����Ϊ����������
dcmEst=[1 0 0; 0 1 0; 0 0 1];
wx=1;   %1��/��Ľ��ٶ�
wy=2;
wz=3;
W=[wx wy wz]*pi/180;    %���Ƕ�ת��Ϊ����
Theta=W*imu_interval_s;   %��ʱ�����ĽǶȱ仯����
imu_sequence = 200;     %�ۻ�����
graf(imu_sequence,4)=zeros;      %��ͼ�����ʼ��
for n = 1:imu_sequence          %ѭ��imu_sequence�ν��о�����£���100�������100*0.02=2s������仯Ӧ��Ϊ2��4��6
    dR(3)=zeros;
    for k = 1:3
        dR=cross(Theta,dcmEst(k,:));
        dcmEst(k,:)=dcmEst(k,:)+dR;
    end
    %������
    error=-dot(dcmEst(1,:),dcmEst(2,:))*0.5;
    %���У��
    x_est = dcmEst(2,:) * error;
    y_est = dcmEst(1,:) * error;
    dcmEst(1,:) = dcmEst(1,:) + x_est;
    dcmEst(2,:) = dcmEst(2,:) + y_est;
    %������
    dcmEst(3,:) = cross(dcmEst(1,:), dcmEst(2,:));
    if 1
        %̩��չ����һ������
        disp('taile');
        dcmEst(1,:)=0.5*(3-dot(dcmEst(1,:),dcmEst(1,:))) * dcmEst(1,:);
        dcmEst(2,:)=0.5*(3-dot(dcmEst(2,:),dcmEst(2,:))) * dcmEst(2,:);
        dcmEst(3,:)=0.5*(3-dot(dcmEst(3,:),dcmEst(3,:))) * dcmEst(3,:);
    else
        %ƽ����
        disp('norm');
        dcmEst(1,:)=dcmEst(1,:)/norm(dcmEst(1,:));
        dcmEst(2,:)=dcmEst(2,:)/norm(dcmEst(2,:));
        dcmEst(3,:)=dcmEst(3,:)/norm(dcmEst(3,:));
    end

    %ת��Ϊŷ����
    graf(n,1)=n*imu_interval_s;
    %graf(n,2)=atan2(dcmEst(3,2),dcmEst(3,3));      %yaw   
    %graf(n,3)=-asin(dcmEst(3,1));      %pitch               
    %graf(n,4)=atan2(dcmEst(2,1),dcmEst(1,1));      %roll
    %ʹ��matlab������[yaw, pitch, roll] = dcm2angle(dcm)
    %[graf(n,2),graf(n,3),graf(n,4)] = dcm2angle(dcmEst);
    %ʹ����Ԫ������ת��
    q = dcm2quat(dcmEst);
    [graf(n,2),graf(n,3),graf(n,4)] = quat2angle(q);
end
figure
hold on
%ת��Ϊ�ǶȲ���ͼ
plot(graf(:,1),graf(:,2)*(180/pi),'+b');%yaw
plot(graf(:,1),graf(:,3)*(180/pi),'.r');%pitch
plot(graf(:,1),graf(:,4)*(180/pi),'.g');%roll
grid