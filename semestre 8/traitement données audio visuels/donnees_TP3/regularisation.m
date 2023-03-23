

function beta= regularisation(k_voisins,k_new,k_old)
beta = 0;
[m,n]= size(k_voisins)
for i=1:m
    for j=1:n
        if k_voisins(i,j)~=k_new
            beta=beta+1;
        end
    end
end
end