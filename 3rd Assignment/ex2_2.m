%2.2 Real Signals
clear all; close all;
%% Delay-and-Sum beamforming
%1
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

audiowrite('real_ds.wav',y_teliko,fs);

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
W=buffer(x(:,4),1200);
[r,c]=size(W);
counter=0;
th=0;
msnr=zeros(1,c);
ns=x(1:0.5*fs,4);
Pn=mean(ns.^2);
sum=0;
for i=1:c
    Px=mean(W(:,i).^2);
    Ps=abs(Px-Pn);
    snr1=10*log10(Ps/Pn);
    if snr1>th
        counter=counter+1;
        if snr1>35
            snr1=35;
        end
        sum=sum+snr1;
    end
end
SSNR=(sum/counter);

W=buffer(y_teliko,1200);
[r,c]=size(W);
counter=0;
th=0;
msnr=zeros(1,c);
ns=y_teliko(1:0.5*fs);
Pn=mean(ns.^2);
sum=0;
for i=1:c
    Px=mean(W(:,i).^2);
    Ps=abs(Px-Pn);
    snr1=10*log10(Ps/Pn);
    if snr1>th
        counter=counter+1;
        if snr1>35
            snr1=35;
        end
        sum=sum+snr1;
    end
end
SSNR2=(sum/counter);

%% Post-filtering with Wiener filter - bonus
%1
N=buffer(y_teliko,0.03*fs,0.015*fs);
h=hamming(0.03*fs);
[m,n]=size(N);
W2=zeros(0.03*fs,n);
Pw2=zeros(m,n);
filtered=zeros(m,n);
Pu=pwelch(N(:,4),[],[],m,'twosided');

for i=1:n
   Pw2(:,i)=pwelch(N(:,i),[],[],m,'twosided');
   Hw=1 - (Pu./Pw2(:,i));
   W2(:,i)=N(:,i).*h;
   W2(:,i)=fft(W2(:,i));
   exit=Hw.*W2(:,i);
   filtered(:,i)=ifft(exit);
end

j=0;
output = zeros(m+m*n/2,1);
for i=1:n
    output(1+j*m/2:m+j*m/2)=filtered(:,i)+output(1+j*m/2:m+j*m/2);
    j=j+1;
end

audiowrite('real_mmse.wav',output,fs);

%2
figure(7);
subplot(4, 1, 1),plot(source);
xlabel('Time (s)'), title('Clear Voice Signal');
subplot(4, 1, 2),plot(x(:,4));
xlabel('Time (s)'), title('Signal from central mic');
subplot(4, 1, 3),plot(y_teliko);
xlabel('Time (s)'), title('Input in Wiener Filter');
subplot(4, 1, 4),plot(output);
xlabel('Time (s)'), title('Output from Wiener Filter');

figure(8);
[S,F,T,P]  = spectrogram(source);
subplot(4, 1, 1);
surf(T,F,10*log10(P),'edgecolor','none');
view(0,90);
title('Spectogram of Clear Voice Signal');

[S,F,T,P]  = spectrogram(x(:,4));
subplot(4, 1, 2);
surf(T,F,10*log10(P),'edgecolor','none');
view(0,90);
title('Spectogram of Signal from central mic');

[S,F,T,P]  = spectrogram(y_teliko);
subplot(4, 1, 3);
surf(T,F,10*log10(P),'edgecolor','none');
view(0,90);
title('Spectogram of Input in Wiener Filter');

[S,F,T,P]  = spectrogram(output);
subplot(4, 1, 4);
surf(T,F,10*log10(P),'edgecolor','none');
view(0,90);
title('Spectogram of Output from Wiener Filter');

%3
%to SSNR ths eisodou exei hdh upologiste ws SSNR2
W=buffer(output,1200);
[r,c]=size(W);
counter=0;
th=0;
msnr=zeros(1,c);
ns=output(1:0.5*fs);
Pn=mean(ns.^2);
sum=0;
for i=1:c
    Px=mean(W(:,i).^2);
    Ps=abs(Px-Pn);
    snr1=10*log10(Ps/Pn);
    if snr1>th
        counter=counter+1;
        if snr1>35
            snr1=35;
        end
        sum=sum+snr1;
    end
end
SSNR3=(sum/counter);

%4
mSSNR=(SSNR+SSNR2)/2;
veltiosi = 100*(SSNR3-mSSNR)/mSSNR;