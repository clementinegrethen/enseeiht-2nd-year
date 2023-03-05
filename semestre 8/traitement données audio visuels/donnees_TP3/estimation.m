function [moyenne,variance] = estimation(echantillons)
    moyenne=mean(echantillons);
    sigma=std(echantillons)
    variance=sigma.^2;
end

