function X = moindres_carres(D_app)
A=[];
n=size(D_app,2)
B= zeros(n+1,1)
B(n+1)=1
A=[];
x=D_app(1,:);
y=D_app(2,:);
for i = 1:n
    A(i, :) = [x(i)^2, x(i) * y(i), y(i)^2, x(i), y(i), 1];
end
A = [A; [1, 0, 1, 0, 0, 0]];
X=A\B
end


