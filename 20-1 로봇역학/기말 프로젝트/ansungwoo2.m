%초기값 설정
Sampling_Period=0.01;
Simulation_Time=2;
Run_Time=0:Sampling_Period:Simulation_Time;
Sample_Number=length(Run_Time);
T=ones(Sample_Number,2);

Gravity=9.8;

Link1=0.7;
Link2=0.5;

Mass1=3;
Mass2=2;

Link_center1=0.35;
Link_center2=0.25;

Theta=zeros(Sample_Number,2);

Theta(1,1)=45*pi/180;
Theta(1,2)=90*pi/180;

input1=input('각속도1:');
input2=input('각속도2:');


%각 변화
for k=1:Sample_Number-1
    
    Theta(k+1,1)=Theta(k,1)-input1*Sampling_Period*pi/180;
    Theta(k+1,2)=Theta(k,2)+input2*Sampling_Period*pi/180;
    
end

%각속도
Diff_t=zeros(Sample_Number,2);

%각속도 계산
for k=1:Sample_Number-1
    
    Diff_t(k,:)=(Theta(k+1,:)-Theta(k,:))/Sampling_Period;
    
end

%각가속도
DDiff_t=zeros(Sample_Number,2);

%각가속도 계산
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



%그래프 그리기
for k=1:Sample_Number
    
    Rot1 = [cos(Theta(k,1)) -sin(Theta(k,1)) 0 0; sin(Theta(k,1)) cos(Theta(k,1)) 0 0; 0 0 1 0; 0 0 0 1];
    Rot2 = [cos(Theta(k,2)) -sin(Theta(k,2)) 0 0; sin(Theta(k,2)) cos(Theta(k,2)) 0 0; 0 0 1 0; 0 0 0 1];
    
    Trans1 = [1 0 0 0; 0 1 0 Link1; 0 0 1 0; 0 0 0 1];
    Trans2 = [1 0 0 0; 0 1 0 Link2; 0 0 1 0; 0 0 0 1];
    
    A1 = Rot1*Trans1;
    End_effector = Rot1*Trans1*Rot2*Trans2;
    
    X1 = [0 A1(1,4) End_effector(1,4)];
    Y1 = [0 A1(2,4) End_effector(2,4)];
    x_1=A1(1,4);
    x_2=End_effector(1,4);
    y_1= A1(2,4);
    y_2= End_effector(2,4);
    
    plot(X1,Y1,'color','r');
    text(0,-0.5,['Time = ', num2str(double(k*Sampling_Period)), ' s']);
    text1=['T_Link1=',num2str(T(k,1))];
    text2=['T_Link2=',num2str(T(k,2))];
    
    text(x_1,y_1,text1);
    text(x_2,y_2,text2);
    axis([-1 1 -1 1]);
    grid on;
    drawnow;
    hold off
end