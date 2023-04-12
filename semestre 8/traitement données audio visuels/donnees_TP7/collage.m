function u = collage(r,s,interieur)
% on convertit r et s au format double
r=double(r);
s=double(s);
u=r;
% calcul de la matrice A: -DX^T DX - DY^TDY
[n,m,l]=size(r);
e = ones(n*m,1);
Dx = spdiags([-e e],[0 n],n*m,m*n);
Dx(end-n+1:end,:) = 0;
Dy = spdiags([-e e],[0 1],n*m,n*m);
Dy(n:n:end,:) = 0;
A = -Dx'*Dx-Dy'*Dy;
% On impose la condition au bord u = c
bord_r=ones(n,m)
bord_r(2:n-1,2:m-1)=zeros(n-2, m-2);
indices_bord_r= find(bord_r==1);
n_bord_r=length(indices_bord_r);
n_r=n*m;
A(indices_bord_r,:) = sparse(1:n_bord_r,indices_bord_r,ones(n_bord_r,1),n_bord_r,n_r);
for k = 1:size(r,3)
	u_k = u(:,:,k);
	s_k = s(:,:,k);

    g_x=Dx*u_k(:);
    g_y=Dy*u_k(:);

    div_s_x=Dx*s_k(:);
    div_s_y=Dy*s_k(:);
    
    g_x(interieur)=div_s_x(interieur);
    g_y(interieur)=div_s_y(interieur);
    
    b_k = -Dx'*g_x-Dy'*g_y;
    b_k(indices_bord_r)=u_k(indices_bord_r);
    
    u_k=A\b_k;
    u(:,:,k) = reshape(u_k,n,m);

end


