function [triplets] = appariement_Triplets(pics_t, pics_f, n_v, delta_t, delta_f)
  triplets = [];
  n = length(pics_t);
  
  for i = 1:n
    nhood = find(abs(pics_f - pics_f(i)) <= delta_f & 0 < (pics_t - pics_t(i)) & (pics_t - pics_t(i)) <=delta_t, n_v);
    for j = 1:length(nhood)-1  % we need to have at least two neighbors
      % Ajout du triplet
      neighborindex1 = nhood(j);
      neighborindex2 = nhood(j+1);
      triplets = [triplets; pics_f(i), pics_f(neighborindex1), pics_f(neighborindex2), pics_t(i), pics_t(neighborindex1), pics_t(neighborindex2)];
    end
  end

end

