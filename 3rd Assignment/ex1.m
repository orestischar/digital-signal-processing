%1o meros
clear all; close all;

d=0.04;
us=pi/2;
w=2000*pi*2;
c=340;

u=(0:180);
u=u*pi/180;

for N=[4 8 16]
    figure(1);
    B = (1/N)*(sin((N*w*d/(2*c))*(cos(u)-cos(us)))) ./ (sin((w*d/(2*c))*(cos(u)-cos(us))));
    semilogy(u,abs(B));
    hold on
end
title('Delay-amd-sum beam pattern in dB');
legend('N=4','N=8','N=16');
xlabel('Angle (rad)');
hold off

N=8;
for d=[0.04 0.08 0.16]
    figure(2);
    B = (1/N)*(sin((N*w*d/(2*c))*(cos(u)-cos(us)))) ./ (sin((w*d/(2*c))*(cos(u)-cos(us))));
    semilogy(u,abs(B));
    hold on
end
title('Delay-amd-sum beam pattern in dB');
legend('d=4cm','d=16cm','d=8cm');
xlabel('Angle (rad)');
hold off

N=8;
d=0.04
u=(-180:180);
u=u*pi/180;
i=3
th=[0 45 90];
for us = [0 pi/4 pi/2]
    figure(i);
    B = (1/N)*(sin((N*w*d/(2*c))*(cos(u)-cos(us)))) ./ (sin((w*d/(2*c))*(cos(u)-cos(us))));
    semilogr_polar(u,abs(B));
    title(['Delay-amd-sum beam pattern for angle ' num2str(th(i-2)) ]);
    i=i+1;
end
