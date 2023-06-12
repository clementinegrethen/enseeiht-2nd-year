function [paires_associes] = appariement(pics_t, pics_f, n_v, delta_t, delta_f)

  paires_associes = [];
  n = length(pics_t);
  % Parcours des pics spectraux de la trame t
  for i = 1:n
    nhood = find(abs(pics_f - pics_f(i)) <= delta_f & 0 < (pics_t - pics_t(i)) & (pics_t - pics_t(i)) <=delta_t, n_v);
    for j = 1:length(nhood)
      % Ajout de la paire
      neighborindex = nhood(j);
      paires_associes = [paires_associes; pics_f(i), pics_f(neighborindex), pics_t(i), pics_t(neighborindex)];
    end

  end

end
