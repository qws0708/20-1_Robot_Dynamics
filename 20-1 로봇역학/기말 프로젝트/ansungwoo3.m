%%%%%%%%%%%%%%%%%%%%%%3-1.원 따라 그리기%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%초기값 설정
Sampling_Period=0.01;
Simulation_Time=2;
Run_Time=0:Sampling_Period:Simulation_Time;
Sample_Number=length(Run_Time);

Link1=0.7;
Link2=0.5;

Mass1=3;
Mass2=2;

%Center of mass
Link_center1=0.35;
Link_center2=0.25;

Gravity=9.8;

%반지름
Round=0.3;

%좌표값 초기화
Position_end=ones(Sample_Number,2);
Theta=ones(Sample_Number,2);
T=ones(Sample_Number,2);


%원의 값 설정
for k=1:Sample_Number
    
    Run_Time=2*pi*k/Sample_Number;
    Position_end(k,1)=0.4+Round*cos(Run_Time);
    Position_end(k,2)=-0.5+Round*sin(Run_Time);
    
end

%IK-->angle
for k=1:Sample_Number
    
    Position_x=Position_end(k,1);
    Position_y=Position_end(k,2);
    
    Theta2 = [2*atan((((Link1+Link2)^2-(Position_x^2+Position_y^2))/(Position_x^2+Position_y^2-(Link1-Link2)^2))^0.5) -2*atan((((Link1+Link2)^2-(Position_x^2+Position_y^2))/(Position_x^2+Position_y^2-(Link1-Link2)^2))^0.5)];
    Theta1 = atan2(Position_y,Position_x) - atan(Link2*sin(Theta2)./(Link1+Link2*cos(Theta2)));
    
    Theta(k,1)=Theta1(1);
    Theta(k,2)=Theta2(1);
    
end

Position_x=ones(Sample_Number,3); 
Position_y=ones(Sample_Number,3);

%Fk-->좌표값
for k=1:Sample_Number
    
    Position_x(k,1)=0;
    Position_y(k,1)=0;
    Position_x(k,2)= Link1*cos(Theta(k,1));
    Position_y(k,2)= Link1*sin(Theta(k,1));
    Position_x(k,3)= Link1*cos(Theta(k,1))+Link2*cos(Theta(k,1)+Theta(k,2));
    Position_y(k,3)= Link1*sin(Theta(k,1))+Link2*sin(Theta(k,1)+Theta(k,2));
    
end

Diff_t=ones(Sample_Number,2);

%각속도
for k=1:Sample_Number-1
    
    Diff_t(k,:)=(Theta(k+1,:)-Theta(k,:))/Sampling_Period;
    
end

DDiff_t=zeros(Sample_Number,2);

%각가속도
for k=1:Sample_Number-1
    
    DDiff_t(k,:)=(Diff_t(k+1,:)-Diff_t(k,:))/Sampling_Period;
    
end

%토크
for k=1:Sample_Number
    
    H=[Mass1*Link_center1^2+Mass2*(Link1^2+Link_center2^2+2*Link1*Link_center2*cos(Theta(k,2))) Mass2*Link1*Link_center2*cos(Theta(k,2))+Mass2*Link_center2^2;Mass2*Link1*Link_center2*cos(Theta(k,2))+Mass2*Link_center2^2 Mass2*Link_center2^2];
    
    Corioli=[-1/2*Mass2*Link1*Link2*sin(Theta(k,2))*Diff_t(k,2)^2-Mass2*Link1*Link2*sin(Theta(k,2))*Diff_t(k,1)*Diff_t(k,2) 1/2*Mass2*Link1*Link2*sin(Theta(k,2))*Diff_t(k,1)^2];
    
    G=[Mass1*Gravity*1/2*Link1*cos(Theta(k,1))+Mass2*Gravity*(Link1*cos(Theta(k,1))+1/2*Link2*cos(Theta(k,1)+Theta(k,2))) Mass2*Gravity*1/2*Link2*cos(Theta(k,1)+Theta(k,2))];
    
    T(k,:)=H*[DDiff_t(k,1);DDiff_t(k,2)]+Corioli'+G';
    
end

a=figure;

%그래프
for k=1:Sample_Number
    
    x1=Position_x(k,2);
    x2=Position_x(k,3);
    y1=Position_y(k,2);
    y2=Position_y(k,3);
    
    plot(Position_end(:,1), Position_end(:,2),'b','linewidth',5);
    hold on;
    
    plot(Position_x(k,1),Position_y(k,1),'ks');
    hold on;
    plot(Position_x(k,2),Position_y(k,2),'ks'); 
    hold on;
    plot(Position_x(k,3),Position_y(k,3),'ks'); 
    hold on;
    
    text(0,-0.5,['Time = ', num2str(double(k*Sampling_Period)), ' s']);
    text1=['D_angle=',num2str(Diff_t(k,1))];            %각속도
    text2=['DD_angle=',num2str(DDiff_t(k,1))];          %각가속도
    text3=['D_angle=',num2str(Diff_t(k,2))];
    text4=['DD_angle=',num2str(DDiff_t(k,2))];
    
    text(x1,y1,text1);
    text(x2,y2,text3);
    text(x1,y1+0.1,text2);
    text(x2,y2+0.1,text4);
    
    plot([Position_x(k,1) Position_x(k,2)],[Position_y(k,1) Position_y(k,2)],'g','linewidth',2);
    hold on;
    plot([Position_x(k,2) Position_x(k,3)],[Position_y(k,2) Position_y(k,3)],'y','linewidth',2);
    hold on;
    
  
    axis([-1 1 -1 1])
    grid on;
    drawnow;
    hold off;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%3-2. 직선 그리기%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

clc;

close all;

%초기값 설정
Sampling_Period=0.01;
Simulation_Time=2;
Run_Time=0:Sampling_Period:Simulation_Time;
Sample_Number=length(Run_Time);

Link1=0.7;
Link2=0.5;

Mass1=3;
Mass2=2;

%center of mass
Link_center1=0.35;
Link_center2=0.25;

Gravity=9.8;

%좌표값 초기화
Position_end=ones(Sample_Number,2);
Theta=ones(Sample_Number,2);
T=ones(Sample_Number,2);

%좌표 설정
for k=1:Sample_Number
    
   Position_end(k,1)=-0.8*k/Sample_Number;
   Position_end(k,2)=0.5;
   
end

%IK-->angle
for k=1:Sample_Number
    
    Position_x=Position_end(k,1);
    Position_y=Position_end(k,2);
    
    Theta2 = [2*atan((((Link1+Link2)^2-(Position_x^2+Position_y^2))/(Position_x^2+Position_y^2-(Link1-Link2)^2))^0.5) -2*atan((((Link1+Link2)^2-(Position_x^2+Position_y^2))/(Position_x^2+Position_y^2-(Link1-Link2)^2))^0.5)];
    Theta1 = atan2(Position_y,Position_x) - atan(Link2*sin(Theta2)./(Link1+Link2*cos(Theta2)));
    
    Theta(k,1)=Theta1(1);
    Theta(k,2)=Theta2(1);
    
end

Position_x=ones(Sample_Number,3); 
Position_y=ones(Sample_Number,3);

%Fk-->좌표값
for k=1:Sample_Number
    
    Position_x(k,1)=0;Position_y(k,1)=0;
    Position_x(k,2)= Link1*cos(Theta(k,1));
    Position_y(k,2)= Link1*sin(Theta(k,1));
    Position_x(k,3)= Link1*cos(Theta(k,1))+Link2*cos(Theta(k,1)+Theta(k,2));
    Position_y(k,3)= Link1*sin(Theta(k,1))+Link2*sin(Theta(k,1)+Theta(k,2));
    
end

Diff_t=zeros(Sample_Number,2);

%각속도
for k=1:Sample_Number-1
    
    Diff_t(k,:)=(Theta(k+1,:)-Theta(k,:))/Sampling_Period;
    
end

DDiff_t=zeros(Sample_Number,2);

%각가속도
for k=1:Sample_Number-1
    
    DDiff_t(k,:)=(Diff_t(k+1,:)-Diff_t(k,:))/Sampling_Period;
    
end

%토크
for k=1:Sample_Number
    
    H=[Mass1*Link_center1^2+Mass2*(Link1^2+Link_center2^2+2*Link1*Link_center2*cos(Theta(k,2))) Mass2*Link1*Link_center2*cos(Theta(k,2))+Mass2*Link_center2^2;Mass2*Link1*Link_center2*cos(Theta(k,2))+Mass2*Link_center2^2 Mass2*Link_center2^2];
    
    Corioli=[-1/2*Mass2*Link1*Link2*sin(Theta(k,2))*Diff_t(k,2)^2-Mass2*Link1*Link2*sin(Theta(k,2))*Diff_t(k,1)*Diff_t(k,2) 1/2*Mass2*Link1*Link2*sin(Theta(k,2))*Diff_t(k,1)^2];
    
    G=[Mass1*Gravity*1/2*Link1*cos(Theta(k,1))+Mass2*Gravity*(Link1*cos(Theta(k,1))+1/2*Link2*cos(Theta(k,1)+Theta(k,2))) Mass2*Gravity*1/2*Link2*cos(Theta(k,1)+Theta(k,2))];
    
    T(k,:)=H*[DDiff_t(k,1);DDiff_t(k,2)]+Corioli'+G';
    
end

b=figure;

%그래프
for k=1:Sample_Number
    
    X1=Position_x(k,2);
    X2=Position_x(k,3);
    Y1=Position_y(k,2);
    Y2=Position_y(k,3);
    
    plot(Position_end(:,1), Position_end(:,2),'b','linewidth',5);
    hold on;
    plot(Position_x(k,1),Position_y(k,1),'ks');
    hold on;
    plot(Position_x(k,2),Position_y(k,2),'ks'); 
    hold on;
    plot(Position_x(k,3),Position_y(k,3),'ks'); 
    hold on;
    text(0,-0.5,['Time = ', num2str(double(k*Sampling_Period)), ' s']);
    text1=['D_angle=',num2str(Diff_t(k,1))];        %각속도
    text2=['DD_angle=',num2str(DDiff_t(k,1))];      %각가속도
    text3=['D_angle=',num2str(Diff_t(k,2))];
    text4=['DD_angle=',num2str(DDiff_t(k,2))];
    
    text(X1,Y1,text1);
    text(X2,Y2,text3);
    text(X1,Y1+0.1,text2);
    text(X2,Y2+0.1,text4);
    
    plot([Position_x(k,1) Position_x(k,2)],[Position_y(k,1) Position_y(k,2)],'g','linewidth',2);
    hold on;
    plot([Position_x(k,2) Position_x(k,3)],[Position_y(k,2) Position_y(k,3)],'y','linewidth',2);
    hold on;
   
  
    axis([-1 1 -1 1])
    grid on;
    drawnow;
    hold off;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%3-3. 사각형 그리기%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

clc;

close all;

%초기값 설정
Sampling_Period=0.01;
Simulation_Time=2;
Run_Time=0:Sampling_Period:Simulation_Time;
Sample_Number=length(Run_Time);

Link1=0.7;
Link2=0.5;

Mass1=3;
Mass2=2;

%center of mass
Link_center1=0.35;
Link_center2=0.25;

Gravity=9.8;

%초기값 설정
Position=zeros(Sample_Number,2);
Theta=ones(Sample_Number,2);
T=zeros(Sample_Number,2);

%0.5 정사각형
for k=1:Sample_Number
    
    if k<=Sample_Number/4
        Position(k,1)=-0.2-0.5*k/(Sample_Number/4);
        Position(k,2)=-0.3;
        
    elseif k<=Sample_Number/2
        Position(k,1)=-0.7;
        Position(k,2)=-0.3-0.5*(k-Sample_Number/4)/(Sample_Number/4);
    
    elseif k<=3*Sample_Number/4
        Position(k,1)=-0.7+0.5*(k-Sample_Number/2)/(Sample_Number/4);
        Position(k,2)=-0.8;
        
    elseif k<=Sample_Number
        Position(k,1)=-0.2;
        Position(k,2)=-0.8+0.5*(k-3*Sample_Number/4)/(Sample_Number/4);
    end
  
end

%IK-->angle
for k=1:Sample_Number
    
    Px=Position(k,1);
    Py=Position(k,2);
    
    Theta2 = [2*atan((((Link1+Link2)^2-(Px^2+Py^2))/(Px^2+Py^2-(Link1-Link2)^2))^0.5) -2*atan((((Link1+Link2)^2-(Px^2+Py^2))/(Px^2+Py^2-(Link1-Link2)^2))^0.5)];
    Theta1 = atan2(Py,Px) - atan(Link2*sin(Theta2)./(Link1+Link2*cos(Theta2)));
    
    Theta(k,1)=Theta1(1);
    Theta(k,2)=Theta2(1);
    
end

Position_x=ones(Sample_Number,3); 
Position_y=ones(Sample_Number,3);

%Fk
for k=1:Sample_Number
    
    Position_x(k,1)=0;
    Position_y(k,1)=0;
    Position_x(k,2)= Link1*cos(Theta(k,1));
    Position_y(k,2)= Link1*sin(Theta(k,1));
    Position_x(k,3)= Link1*cos(Theta(k,1))+Link2*cos(Theta(k,1)+Theta(k,2));
    Position_y(k,3)= Link1*sin(Theta(k,1))+Link2*sin(Theta(k,1)+Theta(k,2));
end

Diff_t=zeros(Sample_Number,2);

%각속도
for k=1:Sample_Number-1
    
    Diff_t(k,:)=(Theta(k+1,:)-Theta(k,:))/Sampling_Period;
    
end

DDiff_t=zeros(Sample_Number,2);

%각가속도
for k=1:Sample_Number-1
    
    DDiff_t(k,:)=(Diff_t(k+1,:)-Diff_t(k,:))/Sampling_Period;
    
end

%토크
for k=1:Sample_Number
    
    H=[Mass1*Link_center1^2+Mass2*(Link1^2+Link_center2^2+2*Link1*Link_center2*cos(Theta(k,2))) Mass2*Link1*Link_center2*cos(Theta(k,2))+Mass2*Link_center2^2;Mass2*Link1*Link_center2*cos(Theta(k,2))+Mass2*Link_center2^2 Mass2*Link_center2^2];
    
    Corioli=[-1/2*Mass2*Link1*Link2*sin(Theta(k,2))*Diff_t(k,2)^2-Mass2*Link1*Link2*sin(Theta(k,2))*Diff_t(k,1)*Diff_t(k,2) 1/2*Mass2*Link1*Link2*sin(Theta(k,2))*Diff_t(k,1)^2];
    
    G=[Mass1*Gravity*1/2*Link1*cos(Theta(k,1))+Mass2*Gravity*(Link1*cos(Theta(k,1))+1/2*Link2*cos(Theta(k,1)+Theta(k,2))) Mass2*Gravity*1/2*Link2*cos(Theta(k,1)+Theta(k,2))];
    
    T(k,:)=H*[DDiff_t(k,1);DDiff_t(k,2)]+Corioli'+G';
    
end

c=figure;

%그래프
for k=1:Sample_Number
    
    X1=Position_x(k,2);
    X2=Position_x(k,3);
    Y1=Position_y(k,2);
    Y2=Position_y(k,3);
    
    plot(Position(:,1), Position(:,2),'b','linewidth',5);
    hold on;
    plot(Position_x(k,1),Position_y(k,1),'ks');
    hold on;
    plot(Position_x(k,2),Position_y(k,2),'ks'); 
    hold on;
    plot(Position_x(k,3),Position_y(k,3),'ks'); 
    hold on;
    
    text(0,-0.5,['Time = ', num2str(double(k*Sampling_Period)), ' s']);
    text1=['D_angle=',num2str(Diff_t(k,1))];        %각속도
    text2=['DD_angle=',num2str(DDiff_t(k,1))];      %각가속도
    text3=['D_angle=',num2str(Diff_t(k,2))];
    text4=['DD_angle=',num2str(DDiff_t(k,2))];
    
    text(X1,Y1,text1);
    text(X2,Y2,text3);
    text(X1,Y1+0.1,text2);
    text(X2,Y2+0.1,text4);
    
    plot([Position_x(k,1) Position_x(k,2)],[Position_y(k,1) Position_y(k,2)],'g','linewidth',2);
    hold on;
    plot([Position_x(k,2) Position_x(k,3)],[Position_y(k,2) Position_y(k,3)],'y','linewidth',2);
    hold on;
    
  
    axis([-1 1 -1 1])
    grid on;
    drawnow;
    hold off;
    
end




