%meros 3o
fs=1000;
t=linspace(0,2,2*fs);

u=randn([1,length(t)]);
X1=1.5*cos(2*pi*80*t)+2.5*sin(2*pi*150*t);
X=X1+0.15*u;
figure(1);
plot(t,X);
window=0.04*fs;
noverlap=window/2;
[S,F,T,P]=spectrogram(X,window,noverlap,window,fs);
figure(2);
surf(T,F,abs(S),'edgecolor','none');
view(0,90);
%3g
[s, f]= wavescales('morl',fs);
cwt = cwtft({X,1/fs}, 'scales',s,'wavelet','morl');
cwt_v=abs(cwt.cfs);
figure(3);
surf(t,f,cwt_v,'edgecolor','none'); 
view(0,90);

%3.2
%a
X2=1.5*cos(2*pi*40*t)+1.5*sin(2*pi*100*t);
Xd1=zeros(1,length(t));
Xd1(625)=5;
Xd1(650)=1;
X3=X2+0.15*u+Xd1;
figure(4);
plot(t,X3);
%b
k=0;
for i =[0.06,0.04,0.02]
    k=k+1;
    window2=i*fs;
    noverlap2=window2/2;
    [S2,F2,T2]=spectrogram(X3,window2,noverlap2,window2,fs);
    figure(4+k);
    contour(T2,F2,abs(S2));
end
[s, f]= wavescales('morl',fs);
cwt = cwtft({X3,1/fs}, 'scales',s,'wavelet','morl');
cwt_v=abs(cwt.cfs);
figure(8);
contour(t,f,cwt_v);