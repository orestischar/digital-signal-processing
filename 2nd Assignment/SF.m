function [sf] = SF (i,j,Db,P)

if (Db>=-3 && Db<-1)
    sf=17*Db-0.4*P(j)+11;
elseif (Db>=-1 && Db<0)
    sf=(0.4*P(j)+6)*Db;
elseif (Db>=0 && Db<1)
    sf=-17*Db;
elseif (Db>=1 && Db<8)
    sf=(0.15*P(j)-17)*Db-0.15*P(j);
end


