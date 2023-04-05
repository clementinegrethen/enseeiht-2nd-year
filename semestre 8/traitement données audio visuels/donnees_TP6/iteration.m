function [x_S,y_S] = iteration(x,y,Fx,Fy,gamma,A)
    indice=sub2ind(size(Fx),round(y),round(x));
    Bx=-gamma*(Fx(indice));
    By=-gamma*(Fy(indice));
    x_S=A*x+Bx;
    y_S=A*y+By;
end 