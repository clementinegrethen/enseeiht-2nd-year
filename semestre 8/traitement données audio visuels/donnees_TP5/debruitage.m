function u_kp1 = debruitage(b,u_k,lambda,Dx,Dy,epsilon)
   [nb,~]=size(u_k);
    W_k = 1./sqrt((Dx*u_k).^2+(Dy*u_k).^2 +epsilon);
    W_k = spdiags(W_k,0,nb,nb);
    Lap = -Dx'*W_k*Dx -Dy'*W_k*Dy;
    Ak = (speye(nb) -lambda*Lap);
    u_kp1 = Ak\b;
