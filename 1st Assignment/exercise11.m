%erwthma 1,1
%hello matlab,my old friend
filename='speech_utterance.wav';
x=audioread(filename);
f=16000;
%duration of hamming window
d=0.02;
sound(x,16000);
L=d*f;
M=buffer(x,L,L-1,'nodelay');
h=hamming(L);
[m,n]=size(M);
N=zeros(L,n);
for i=1:n
    N(:,i)=M(:,i).*h;
end

%square array elements
Na= N.^2;
%array in which i element is the energy of each window
En=sum(Na,1);
w=linspace(1,n,n);
%plot(w,En);
xn(1)=x(1);
for i=2:length(x)
    xn(i)=abs(sign(x(i))-sign(x(i-1)));
end
M=buffer(xn,L,L-1,'nodelay');
N=zeros(L,n);
for i=1:n
    N(:,i)=M(:,i).*h;
end
Zn=sum(N,1);
plot(w,Zn);