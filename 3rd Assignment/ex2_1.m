%2.1
clear all; close all;
%% Delay-and-sum Beamforming 
N=7;
n=(0:6);
d=0.04;
fs=48000;
us1=pi/4;
us2=3*pi/4;
p=(n-(N-1)/2)*d;
c=340;

x(:,1)=audioread('sensor_0.wav');
x(:,2)=audioread('sensor_1.wav');
x(:,3)=audioread('sensor_2.wav');
x(:,4)=audioread('sensor_3.wav');
x(:,5)=audioread('sensor_4.wav');
x(:,6)=audioread('sensor_5.wav');
x(:,7)=audioread('sensor_6.wav');
source=audioread('source.wav');
for i=1:7
X(:,i)=fft(x(:,i));
end
w=([-length(x)/2:(length(x)-1)/2]./length(x))*2*pi;

for i=1:7
dks(:,i)=exp(-(j*w*fs*p(i)*cos(us1)/c));
end

y_teliko=0;
for i=1:7
Y(:,i)=dks(:,i).*X(:,i)/N;
y(:,i)=ifft(Y(:,i));
y_teliko=y_teliko+real(y(:,i));
end

audiowrite('sim_ds.wav',y_teliko,fs);

%2
figure(1);
plot(source);
title('Clear voice signal');
xlabel('Time(s)');
figure(2);
plot(x(:,4));
title('Signal from central mic');
xlabel('Time(s)');
figure(3);
plot(y_teliko);
title('Output signal from delay-and-sum beamformer');
xlabel('Time(s)');



[S,F,T,P]  = spectrogram(source);
figure(4);
surf(T,F,10*log10(P),'edgecolor','none');
view(0,90);
title('Spectogram of clear voice signal');

[S,F,T,P]  = spectrogram(x(:,4));
figure(5);
surf(T,F,10*log10(P),'edgecolor','none');
view(0,90);
title('Spectogram of signal from central mic');

[S,F,T,P]  = spectrogram(y_teliko);
figure(6);
surf(T,F,10*log10(P),'edgecolor','none');
view(0,90);
title('Specrogram of signal from delay-and-sum beamformer');

%3
snr_central_mic = 10*log10(mean(source.^2)/mean((x(:,4)-source).^2)); 
snr_y_teliko = 10*log10(mean(source.^2)/mean((y_teliko-source).^2));  

%% Monokanaliko Wiener filtrarisma
noise=x(:,4)-source;
s=source(0.36*fs:0.39*fs);
u=noise(0.36*fs:0.39*fs);
x1=x(0.36*fs:0.39*fs,4);
[Pu,f]=pwelch(u,[],[],length(u),fs,'twosided');
[Px,f]=pwelch(x1,[],[],length(x1),fs,'twosided');
[Ps,f]=pwelch(s,[],[],length(s),fs,'twosided');
Hw=1-(Pu./Px);
figure(7);

plot(f,10*log10(abs(Hw)));
xlim([0,8000]);
title('Filter response IIR Wiener');
ylabel('H_w');
xlabel('Frequency (Hz)');
%2
nsd=abs(1-Hw).^2;
figure(8);
plot(f,10*log10(nsd));
xlim([0,8000]);
title('Speech Distortion Index');
ylabel('n_sd');
xlabel('Frequency (Hz)');


%3
Xw=fft(x1);
Yw=Hw.*Xw;
yw=ifft(Yw);
[Py,f]=pwelch(yw,[],[],length(s),fs,'twosided');

figure(9);
hold on
plot(f,10*log10(Ps));
plot(f,10*log10(Px));
plot(f,10*log10(Py));
plot(f,10*log10(Pu));
xlim([0,8000]);
legend('clear voice signal','wiener input','wiener output','noise in input');
title('Wiener Power Spectrums');
hold off

%4
snr_yw = 10*log10(mean(s.^2)/mean((yw-s).^2));
veltiosi = 100*(snr_y_teliko-snr_yw)/snr_yw

dns=y_teliko(0.36*fs:0.39*fs);
[Pdns,f]=pwelch(dns,[],[],length(dns),fs,'twosided');

figure(10);
hold on
plot(f,10*log10(Ps));
plot(f,10*log10(Px));
plot(f,10*log10(Py));
plot(f,10*log10(Pdns));
xlim([0,8000]);
legend('clear voice signal','input','wiener output','delay-and-sum beamfomer output');
title('Wiener/Beamforming Power Spectrums');
hold off

