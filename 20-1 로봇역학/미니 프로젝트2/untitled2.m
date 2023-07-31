pi =3.141592
a = pi/180

theta1 = 30*a          %초기 세타값
theta2 = 60*a

l1 = 0.15               %링크 길이(변화x)
l2 = 0.12


%문제2-1


Rot1 = [cos(theta1) -sin(theta1) 0 0; sin(theta1) cos(theta1) 0 0; 0 0 1 0; 0 0 0 1]    	
Rot2 = [cos(theta2) -sin(theta2) 0 0; sin(theta2) cos(theta2) 0 0; 0 0 1 0; 0 0 0 1]

T1 = [1 0 0 l1; 0 1 0 0; 0 0 1 0; 0 0 0 1]
T2 = [1 0 0 l2; 0 1 0 0; 0 0 1 0; 0 0 0 1]

T0_1 = Rot1*T1

T0_2 = Rot1*T1*Rot2*T2

px = T0_2(1,4)         %이동하기전 엔드이팩터 좌표
py = T0_2(2,4)


%문제2-2

P1 = [l1*cos(theta1)+l2*cos(theta1+theta2);l1*sin(theta1)+l2*sin(theta1+theta2)]      %이동하기전 엔드이팩터 좌표

jaco = [-l1*sin(theta1)-l2*sin(theta1+theta2) -l2*sin(theta1+theta2);l1*cos(theta1)+l2*cos(theta1+theta2) l2*cos(theta1+theta2)]

d_theta = [2*a;3*a]

dP = jaco*d_theta

P2 = P1 + dP

px2=P2(1,1)             %이동후 엔드이팩터 좌표
py2=P2(2,1)



%문제2-3


th2 = [2*atan((((l1+l2)^2-(px2^2+py2^2))/(px2^2+py2^2-(l1-l2)^2))^0.5) -2*atan((((l1+l2)^2-(px2^2+py2^2))/(px2^2+py2^2-(l1-l2)^2))^0.5)]
th2 = 1.0928
th1 = atan2(py2,px2) - atan(l2*sin(th2)./(l1+l2*cos(th2)))
th1 = 0.5622

or_th1 = 32*a       %초기 세타값
or_th2 = 63*a

error1=or_th1 - th1    %오차값
error2=or_th2 -th2


%문제 2-4


detjaco = l1*l2*sin(theta2)
dseta =detjaco*[l2*cos(theta1+theta2) l2*sin(theta1+theta2);-l2*cos(theta1+theta2)+l1*cos(theta1) -l2*sin(theta1+theta2)-l1*sin(theta1)]*dP


d = 2*a - dseta(1,1)        %오차
dd = 3*a - dseta(2,1)


%문제 2-5


T01 = T0_1
T02 = T0_2

x00 = 0
y00 = 0

x01 = T0_1(1,4)
y01 = T0_1(2,4)

x02 = T0_2(1,4)
y02 = T0_2(2,4)

totallx = [x00,x01,x02]
totally = [y00,y01,y02]

plot(totallx,totally)

hold on




theta1 = 32*a
theta2 = 63*a

Rot1 = [cos(theta1) -sin(theta1) 0 0; sin(theta1) cos(theta1) 0 0; 0 0 1 0; 0 0 0 1]    
Rot2 = [cos(theta2) -sin(theta2) 0 0; sin(theta2) cos(theta2) 0 0; 0 0 1 0; 0 0 0 1]

T1 = [1 0 0 l1; 0 1 0 0; 0 0 1 0; 0 0 0 1]
T2 = [1 0 0 l2; 0 1 0 0; 0 0 1 0; 0 0 0 1]

T0_1 = Rot1*T1

T0_2 = Rot1*T1*Rot2*T2

x11 = T0_1(1,4)
y11 = T0_1(2,4)

x22 = T0_2(1,4)
y22 = T0_2(2,4)

totallx2 = [x00,x11,x22]
totally2 = [y00,y11,y22]

plot(totallx2,totally2)







