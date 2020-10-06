function [S] = ST(P,k) %calculating the ST

    if (k<3 || k>250)
            S=0;
    elseif (P(k)<=P(k+1) || P(k)<=P(k-1))
            S=0;
    elseif (k>2 && k<63 && P(k)>P(k+2)+7 && P(k)>P(k-2)+7)
            S=1;
    elseif (k>=63 && k<127 && P(k)>P(k+2)+7 && P(k)>P(k-2)+7 && P(k)>P(k+3)+7 && P(k)>P(k-3)+7)
            S=1;
    elseif (k>=127 && k<=250 && P(k)>P(k+2)+7 && P(k)>P(k-2)+7 && P(k)>P(k+3)+7 && P(k)>P(k-3)+7 && P(k)>P(k+4)+7 && P(k)>P(k-4)+7 && P(k)>P(k+5)+7 && P(k)>P(k-5)+7 && P(k)>P(k+6)+7 && P(k)>P(k-6)+7)
            S=1;
    else    S=0;
    end
end