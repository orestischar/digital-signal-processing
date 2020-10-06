%2h askhsh
%2.0
M=32;
h=zeros(M,2*M);
g=zeros(M,2*M);
for k=0:M-1
    for n=0:2*M-1
        h(k+1,n+1)=sin((n+0.5)*pi/(2*M))*sqrt(2/M)*cos((2*n+M+1)*(2*k+1)*pi/(4*M));
    end
    for n=0:2*M-1
        g(k+1,n+1)=h(k+1,2*M-n);
    end
end

fs=44100;
L=512;
shma=audioread('music_dsp18.wav');
s2=(shma(:,1)+shma(:,2))/2;
high=max(abs(s2));
s2=s2/high;
x=buffer(s2,512);
figure(12)
plot((1:length(s2)),s2);

plaisia=(size(x,2));

Tg = ask1_2(L); %sunarthsh pou pernei to L ws orisma

s_w=zeros(plaisia,639); 
m_bits=0; %gia ton upologismo ton bits pou xrhsimopoiountai ston kvantisth
for i=1:plaisia
    %2.1
    u=zeros(M,L+2*M-1);
    y=zeros(M,ceil(size(u,2)/M));
    for m=1:M
        u(m,:)=conv(x(:,i),h(m,:));
        y(m,:)=downsample(u(m,:),M);
    end
    %2.2
    Bk=zeros(M,1);
    D=zeros(M,1);
    y_q=zeros(M,size(y,2));
    %2.3
    for k=1:M
        %Bk(k)=8; %an o kvantistis einai statheros
        Bk(k)=ceil(log2(65536/(min(Tg(i,(8*(k-1)+1):8*k))) -1)); %afoy kentrikes suxnothtes fk(1,i)=(2*i-1)*pi/(2*M) 
        m_bits=m_bits+Bk(k);
        D(k)=(max(y(k,:))-min(y(k,:))) / 2^Bk(k);
        %D(k)=2 / 2^Bk(k); %an o kvantistis einai statheros
        [index,quants]=quantiz(y(k,:),(min(y(k,:))+D(k)):D(k):max(y(k,:)),min(y(k,:)):D(k):max(y(k,:)));
        %[index,quants]=quantiz(y(k,:),(-1+D(k)):D(k):1,-1:D(k):1); %an o kvantistis einai statheros
        y_q(k,:)=quants(:);
    end

    %2.3
    wk=zeros(M,size(y_q,2)*M);
    %2.3
    for k=1:M
        wk(k,:) = upsample(y_q(k,:),M);
    end
    wk=transpose(wk);
    y_conv=zeros(M,size(wk,1)+2*M-1);
    for m=1:M
        y_conv(m,:)=conv(wk(:,m),g(m,:));
        %s_w: pinakas me ola ta conv athrismena
        s_w(i,:)=s_w(i,:)+y_conv(m,:);
    end    
end
s=zeros(1,L*plaisia+127);
%epikalupseis
j=0;
for i=1:plaisia
    s(1+j*512:639+j*512) = s_w(i,:) + s(1+j*512:639+j*512);
    j = j+1; 
end 
figure(420);
plot((1:length(s)),s);
sound(s,fs);

s=s(1+63:length(s2)+63); % metatopisti kata paragonta 2M
                         %peirmatatika exoume kalutero apotelesma gia
                         %metatopish = 63
figure(13)
plot(s2 - transpose(s));

err = immse(transpose(s2),s);
m_bits=m_bits/(plaisia*M);
disp(m_bits);
audiowrite('prosarmosmeno_music.wav',s,fs);
%audiowrite('stathero_music.wav',s,fs); %gia stathero kvantisti