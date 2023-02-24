function beta_estime = moindres_carres(d,x,bord)
    beta_0 = bord(1);
    A=[];
    B = bord - beta_0.*((1.-x).^d);
    for j=1:d
     A=[A,nchoosek(d,j)*(x.^j).*((1.-x).^(d-j))];
    end 
    beta_estime=A\B;
end

