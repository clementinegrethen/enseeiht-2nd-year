function AD = attache_donnees(I,moyennes,variances)
 [l,c,d]=size(I);
    N=length(moyennes);
    AD=zeros(l,c,N);
    variances=reshape(variances,1,N);
    for i=1:l
        for j=1:c
            AD(i,j,:)=(log(variances)+((I(i,j)-moyennes).^2)./variances)/2;
        end
    end

end
