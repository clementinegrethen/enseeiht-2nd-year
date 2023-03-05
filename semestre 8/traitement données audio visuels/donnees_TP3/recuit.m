function [U,k] = recuit(U,k,AD,T,beta)
    [l,c,N]=size(AD);
    nb_lignes = 100;
    nb_colonnes = 100;
    for i=1:l
        for j=1:c
            ks=randi(N);
            while (ks==k(i,j))
                ks=randi(N);
            end
             U_s_prime=AD(i,j,ks)+beta*regularisation(k(max(i-1,1):min(i+1,nb_lignes),max(j-1,1):min(j+1,nb_colonnes)),ks,k(i,j));
            if (U_s_prime<U(i,j))
                k(i,j)=ks;
                U(i,j)=U_s_prime;
            else
                if (rand()<exp(-(U_s_prime-U(i,j))/T))
                    k(i,j)=ks;
                    U(i,j)=U_s_prime;
                end
            end
    end
    end 
end 
     


    