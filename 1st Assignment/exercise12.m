clear all;
close all;
clc;
%Meros 2
filename='speech_utterance.wav';
x=audioread(filename);
fs=16000;
%duration of hamming window
d=0.04;
sound(x,fs);
hop=0.02;
[STFT,f,t,nfft,L,n,N]=mySTFT(x,fs,d,hop);
figure();
surf(t,f,abs(STFT), 'edgecolor','none');
xlabel('Time');
ylabel('Frequency');
view(0,90);

%/a/ = [0.748243, 0.797224];
%deigmata apo 1198 mexri 1276
%/o/ = [0.570688, 0.662527];
%deigmata apo 913 mexri 10601

alpha1=N(593:end,2);
alpha1=padarray(alpha1,(L-length(alpha1))/2);

alpha2=N(1:420,3);
alpha2=padarray(alpha2,(L-length(alpha2))/2);

omikron1=N(559:600,3);
omikron1=padarray(omikron1,(L-length(omikron1))/2);

omikron2=N(601:636,3);
omikron2=padarray(omikron2,(L-length(omikron2))/2);

a_f1=abs(fft(alpha1));
a_f2=abs(fft(alpha1));
o_f1=abs(fft(omikron1));
o_f2=abs(fft(omikron2));

figure();
plot(f,a_f1);
figure();
plot(f,a_f2);
figure();
plot(f,o_f1);
figure();
plot(f,o_f2);


%2.3
IFFT=ifft(STFT,nfft);
[Framesize,nFrames]=size(IFFT);
shift=Framesize/2;
output=zeros((nFrames-1)*shift+Framesize,1);

for k=1:nFrames
   start=(k-1)*shift+1;
   finish=Framesize+start-1;
   output(start:finish)=IFFT(:,k)+output(start:finish);
end

t=(1:length(output))/fs;
figure();
plot(t,output);
%sound(output,fs);
audiowrite('speech_utterance_rec.wav',output,fs);
