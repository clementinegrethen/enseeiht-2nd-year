function [D,A] = nmf(S,D_0,A_0,nb)
A=A_0;
D=D_0;
 for k=1:nb
     A_s=A.*(D' * S)./(D' * D * A)
     D_s=D .* (S*A')./ (D * A * A');
     A=A_s;
     D=D_s;
 end 



