function beta_estime = moindres_carres_paire(d,x,bord_inf,bord_sup)
     beta_0 = bord_inf(1);
     gamma_0= bord_sup(1);
     p = length(x);
     A = zeros(2*p,2*d-1);
     B1 = bord_inf - beta_0.*(1-x).^d;
     B2 = bord_sup - gamma_0.*(1-x).^d;
     B = [B1;B2];
    for k = 1:d-1
        A(1:p,k) = (nchoosek(d,k)*x.^k.*(1-x).^(d-k))';
        A(p+1:end,k+d-1) = (nchoosek(d,k)*x.^k.*(1-x).^(d-k))';
    end
    A(1:p,2*d-1) = x.^d;
    A(p+1:end,2*d-1) = x.^d;
    beta_estime=A\B;

end 

     
     





