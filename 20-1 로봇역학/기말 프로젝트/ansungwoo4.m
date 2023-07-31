%초기값 설정(변수 이름에 변수 특성 표기함)
Gravity=9.8;      

Link1=0.32;     
Link2=0.32;     
Weight1=1;      
Weight2=1;       
  
Centrifugal_force1=zeros(Sample_Number,2);  %원심력
Centrifugal_force2=zeros(Sample_Number,2);
T1=zeros(Sample_Number,1);    %토크
T2=zeros(Sample_Number,1);
Total_T=zeros(Sample_Number,2);
angle=zeros(Sample_Number,2);  
Diff_angle=zeros(Sample_Number,2);  %각속도
DDiff_angle=zeros(Sample_Number,2); %각가속도
Control1=zeros(Sample_Number,2);  %제어능력
Control2=zeros(Sample_Number,2);
Position_x=zeros(Sample_Number,3);       %좌표계 위치 
Position_y=zeros(Sample_Number,3);

angle(1,1)=-pi/6;   %초기값 설정
angle(1,2)=-pi/2;

Sampling_Period=0.001;              
Simulation_Time=10;             
Run_Time=0:Sampling_Period:Simulation_Time;   
Sample_Number=length(Run_Time);    

Answer1=input('토크1 입력');
Answer2=input('토크2 입력');
Answer3=input('외란 입력');


%변화하는 토크값
for k=1:Sample_Number
    T1(k)=Answer1*sin(pi*Run_Time(k))+Answer3;
    T2(k)=Answer2*sin(pi*Run_Time(k))+Answer3;
    Total_T(k,:)=[T1(k) T2(k)];
end


for k=1:Sample_Number-1
    %중력항
    Gravity1(k)=Weight1*Gravity*1/2*Link1*cos(angle(k,1))+Weight2*Gravity*(Link1*cos(angle(k,1))+1/2*Link2*cos(angle(k,1)+angle(k,2)));
    Gravity2(k)=Weight2*Gravity*1/2*Link2*cos(angle(k,1)+angle(k,2));
    Total_gravity=[Gravity1(k) Gravity2(k)];
    %원심력
    Centrifugal_force1(k)=(Weight1*Diff_angle(k,1))/Link1;
    Centrifugal_force2(k)=(Weight2*Diff_angle(k,2))/Link2;
    f=[Centrifugal_force1 Centrifugal_force2];
    %관성력
    H11(k)=1/3*Weight1*Link1^2 + Weight2*(Link1^2+1/3*Link2^2+Link1*Link2*cos(angle(k,2)));
    H12(k)=Weight2*(1/3*Link2^2+1/2*Link1*Link1*cos(angle(k,2)));
    H21(k)=H12(k);
    H22(k)=Weight2*1/3*Link2^2;
    M=[H11(k) H12(k); H21(k) H22(k)];
    M_inv=inv(M);
    %제어능력
    Control1(k)=T1(k)-Gravity;
    Control2(k)=T2(k)-Gravity;
    p=[Control1 Control2];
    %코리올리
    Corioli1(k)=-1/2*Weight2*Link1*Link2*sin(angle(k,2)*Diff_angle(k,2)^2-Weight2*Link1*Link2*sin(angle(k,2))*Diff_angle(k,1)*Diff_angle(k,2));
    Corioli2(k)=1/2*Weight2*Link1*Link2*sin(angle(k,2))*Diff_angle(k,1)^2;
    Total_corioli=[Corioli1(k) Corioli2(k)];
    %각가속도
    A_angle=Total_T(k,:)-Total_corioli-Total_gravity;
    DDiff_angle(k+1,:)=(M_inv*A_angle');     %다음 샘플의 각가속도
    Diff_angle(k+1,:)=Diff_angle(k,:)+DDiff_angle(k,:)*Sampling_Period;   %다음 샘플의 각속도
    angle(k+1,:)=angle(k,:)+Diff_angle(k,:)*Sampling_Period;      %다음 샘플의 각도 
    
end

%코리올리 그래프(figure3)
c=figure;
plot(Corioli1,'b','linewidth',1);
hold on;
plot(Corioli2,'r','linewidth',1);
%원심력 그래프(figure1)
a=figure;
a1=plot(Centrifugal_force1,'b','linewidth',1);
hold on;
a2=plot(Centrifugal_force2,'r','linewidth',1);
%제어능력 그래프(figure4)
d=figure;
plot(Control1,'b','linewidth',1);
hold on;
plot(Control2,'r','linewidth',1);
%관성력 그래프(figure2)
b=figure;
plot(H11,'b','linewidth',1);
hold on;
plot(H12,'r','linewidth',1);
hold on;
plot(H21,'y','linewidth',1);
hold on;
plot(H22,'g','linewidth',1);

for k=1:Sample_Number
    Position_x(k,1)=0;
    Position_y(k,1)=0;
    Position_x(k,2)=Link1*cos(angle(k,1));
    Position_y(k,2)=Link1*sin(angle(k,1));
    Position_x(k,3)=Position_x(k,2)+Link2*cos(angle(k,1)+angle(k,2));
    Position_y(k,3)=Position_y(k,2)+Link2*sin(angle(k,1)+angle(k,2));
end

%그래프
e=figure;
for k=1:5:Sample_Number
    plot(Position_x(k,1),Position_y(k,1),'ko');
    hold on;    %초기
    plot(Position_x(k,2),Position_y(k,2),'ko');
    hold on;    %중간
    plot(Position_x(k,3),Position_y(k,3),'rs');
    hold on;    %말단
    
    plot([Position_x(k,1) Position_x(k,2)],[Position_y(k,1) Position_y(k,2)],'r','linewidth',2);    %링크1
    hold on;
    plot([Position_x(k,2) Position_x(k,3)],[Position_y(k,2) Position_y(k,3)],'g','linewidth',2);    %링크2
    hold on;
    
    plot(Position_x(1:k,3),Position_y(1:k,3),'c.');  
    axis([-1 1 -1 0])               
    
    grid on;
    drawnow;
    hold off;
end









