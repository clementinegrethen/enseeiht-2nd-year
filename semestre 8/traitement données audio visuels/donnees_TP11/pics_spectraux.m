function [pics_t, pics_f] = pics_spectraux(S, eta_t, eta_f, epsilon)
  epsilon = 1;
  % on utilise imdilate pour trouver les pics
  strl= strel('rectangle',[eta_t eta_f]);
  J = imdilate(S, strl);
  [pics_f, pics_t] = find(J == S & J > epsilon);
end