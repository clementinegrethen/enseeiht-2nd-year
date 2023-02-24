function y =bezier(x,gamma_0,gamma)
d = length(gamma);
y= gamma_0*(1-x).^d;
for i = 1:d
	y = y+gamma(i)*nchoosek(d,i).*x.^i.*(1-x).^(d-i);
end
end
