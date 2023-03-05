function [y_inf,y_sup] = tirage_aleatoire(x,moyennes,ecarts_types,beta_0,gamma_0)
    parametre = randn(length(ecarts_types),1).*ecarts_types+moyennes;
    d = (length(ecarts_types)-1)/2;
    eps = parametre(end);
    beta = parametre(1:d-1);
    gamma = parametre(d:end-1);
    y_inf = bezier(x,beta_0,[beta;eps]);
    y_sup = bezier(x,gamma_0,[gamma;eps]);
end 