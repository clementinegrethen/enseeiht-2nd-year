function [F_h, F_p] = HPSS(x)
    F_h=medfilt2(x,[1,17])
    F_p=medfilt2(x,[17,1])
end 

