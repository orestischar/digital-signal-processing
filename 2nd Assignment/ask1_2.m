%step 1.0
function [Tg]=ask1_2(L)
    fs=44100;
    
    x=audioread('music_dsp18.wav');
    y=(x(:,1)+x(:,2))/2;
    high=max(abs(y));
    y=y/high;
    x=buffer(y,512);%,0,'nodelay');
    %bark
    f=(1:L/2)*(fs/L);
    b = 13*atan(0.00076*f) + 3.5 *atan((f/7500).^2);
    Tq = 3.64*(f/1000).^(-0.8) - 6.5*exp(-0.6*(f/1000 - 3.3).^2) +  10^(-3)*(f/1000).^4;    %absolute thershold of hearing
    %parathiropoihsh
    w=hann(L);
    n=size(x,2);
    N=zeros(L,n);
    for i=1:n
        N(:,i)=x(:,i).*w;
    end

    y_fft=fft(N,L);

    Tg=zeros(n,L/2);

    for i=1:n
        %step 1.0
        P=90.302 + 10*log10(abs(y_fft(:,i)).^2);
        P=P(1:L/2);
        %step 1.2
        Ptm=zeros(1,L/2);
        if (i==450)
            figure(1)
            plot(f,P);
            figure(2)
            plot(b,P);
        end
        for k=1:L/2
            if ST(P,k)==1
                Ptm(k) = 10*log10(10^(0.1*P(k-1)) + 10^(0.1*P(k)) + 10^(0.1*P(k+1)));
            else
                Ptm(k)=0;
            end
        end
        k=(1:L/2);
        [Pnm]=findNoiseMaskers(P,Ptm,b);
        %display maskers
        if (i==450)
            %disp(find(Ptm>0));
            %disp(find(Pnm>0));
            figure(4)
            plot(k,Ptm);
            figure(5)
            plot(k,Pnm);

        end
        %step 1.3
        [Ptm,Pnm]=checkMaskers(Ptm,Pnm,Tq,b);
        %step 1.4
        j_tm=find(Ptm>0);
        Ttm=zeros(L/2,length(j_tm));
        for j=1:length(j_tm)
            for k=1:L/2
                    s=j_tm(j);
                    if (b(k)<b(s)-3 || b(k)> b(s)+8)
                        Ttm(k,s)=0;
                    else
                        Db=b(k)-b(s);
                        Ttm(k,j)=Ptm(s)-0.275*b(s)+SF(k,s,Db,Ptm)-6.025;
                    end
            end
        end

        k=(1:L/2);
        j_nm=find(Pnm>0);
        %display noise and tone maskers after reduction
        if (i==450)
            %disp(j_tm);
            %disp(j_nm);
            figure(6)
            plot(k,Ptm);
            figure(7)
            plot(k,Pnm);
        end
        Tnm=zeros(L/2,length(j_nm));
        for j=1:length(j_nm)
            for k=1:L/2
                    s=j_nm(j);
                    if (b(k)<b(s)-3 || b(k)> b(s)+8)
                        Tnm(k,j)=0;
                    else
                        Db=b(k)-b(s);
                        Tnm(k,j)=Pnm(s)-0.175*b(s)+SF(k,s,Db,Pnm)-2.025;
                    end
            end
        end
        %step 1.5
        for k=1:L/2
           Tg(i,k)=10.^(0.1*Tq(k));
           for l=1:length(j_tm)
               if(Ttm(k,l)~=0)
               Tg(i,k)=Tg(i,k)+10.^(0.1*Ttm(k,l));
               end
           end
           for m=1:length(j_nm)
               if(Tnm(k,m)~=0)
               Tg(i,k)=Tg(i,k)+10.^(0.1*Tnm(k,m));
               end
           end
        Tg(i,k)=10*log10(Tg(i,k));
        end

    end
    figure(9)
    plot(b,Tg(450,:));
end