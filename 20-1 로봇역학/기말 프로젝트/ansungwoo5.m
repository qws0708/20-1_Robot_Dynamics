%초기값 설정
clear all;

clc;

close all;

Gravity=9.8;

Sampling_Period=0.01;
Simulation_Time=10;
Sample_Number=int16(Simulation_Time/Sampling_Period);

%행렬 초기화
Position_x1=ones(Sample_Number,1); 
Position_y1=ones(Sample_Number,1); 
Poisition_x2=ones(Sample_Number,1); 
Position_y2=ones(Sample_Number,1); 

Theta1=ones(Sample_Number,1);
Theta2=ones(Sample_Number,1);

Diff_theta1=ones(Sample_Number,1);
Diff_theta2=ones(Sample_Number,1);
DDiff_theta1=ones(Sample_Number,1);
DDiff_theta2=ones(Sample_Number,1);

figure;
hold off;

%시작 각도 및 각속도 설정
Diff_theta1(1)=0;  
Diff_theta2(1)=0;  
Theta1(1)=pi/4;  
Theta2(1)=pi-0.5;  

%각가속도 계산
D1=-2*Gravity*sin(Theta1(1))-sin(Theta1(1)-Theta2(1))*Diff_theta2(1)^2;
D2=-Gravity*sin(Theta2(1))+sin(Theta1(1)-Theta2(1))*Diff_theta1(1)^2;
DDiff_theta1(1)=(D1-D2*cos(Theta1(1)-Theta2(1)))/(2-(cos(Theta1(1)-Theta2(1)))^2);
DDiff_theta2(1)=D2-cos(Theta1(1)-Theta2(1))*DDiff_theta1(1);

Position_x1(1)=sin(Theta1(1));
Position_y1(1)=cos(Theta1(1));
Poisition_x2(1)=sin(Theta1(1))+sin(Theta2(1));
Position_y2(1)=cos(Theta1(1))+cos(Theta2(1));


%실행 그래프
for k=2:Sample_Number
    Diff_theta1(k)=Diff_theta1(k-1)+Sampling_Period*DDiff_theta1(k-1);
    Diff_theta2(k)=Diff_theta2(k-1)+Sampling_Period*DDiff_theta2(k-1);
    
    Theta1(k)=Theta1(k-1)+Sampling_Period*Diff_theta1(k);
    Theta2(k)=Theta2(k-1)+Sampling_Period*Diff_theta2(k);
    
    D1=-2*Gravity*sin(Theta1(k))-sin(Theta1(k)-Theta2(k))*Diff_theta2(k)^2;
    D2=-Gravity*sin(Theta2(k))+sin(Theta1(k)-Theta2(k))*Diff_theta1(k)^2;
    
    DDiff_theta1(k)=(D1-D2*cos(Theta1(k)-Theta2(k)))/(2-(cos(Theta1(k)-Theta2(k)))^2);
    DDiff_theta2(k)=D2-cos(Theta1(k)-Theta2(k))*DDiff_theta1(k);
    
    Position_x1(k)=sin(Theta1(k));
    Position_y1(k)=cos(Theta1(k));
    Poisition_x2(k)=sin(Theta1(k))+sin(Theta2(k));
    Position_y2(k)=cos(Theta1(k))+cos(Theta2(k));

    
    plot([0, Position_x1(k), Poisition_x2(k)], [0, -Position_y1(k), -Position_y2(k)],'-o');
    hold on

    axis([-2 2 -2 2]);
    
    title(['Time = ', num2str(double(k)*Sampling_Period, '% 5.3f'), ' s']);
    hold on
    plot(Poisition_x2(1:k), -Position_y2(1:k), 'g');
  
    hold off
    drawnow;
end
