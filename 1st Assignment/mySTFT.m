function [STFT, f, t,nfft,L,n,N] = mySTFT(x, fs, d, hop)
L=d*fs;
hopsize=hop*fs;
noverlap=L-hopsize;
M=buffer(x,L,noverlap,'nodelay');
h=hamming(L);
[m,n]=size(M);
N=zeros(L,n);
for i=1:n
    N(:,i)=M(:,i).*h;
end
nfft=L;
STFT=fft(N,nfft);
f=zeros(1,nfft);
for i=1:nfft
    f(i)=fs*i/nfft;
end
[r,c]=size(STFT);
t=(L/2:hopsize:L/2+(c-1)*hopsize)/fs; 
end