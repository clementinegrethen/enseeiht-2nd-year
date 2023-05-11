function [Y, valeurs_t, valeurs_f] = TFCT(y, f_ech, n_fenetre, n_decalage, fenetre)

signal_buffer=buffer(y,n_fenetre,n_fenetre-n_decalage,"nodelay");
if (fenetre=="rect")
    Signal_carre= ones(n_fenetre,1);
end
if (fenetre=="hann")
    Signal_carre=hann(n_fenetre);
end

Y=fft(Signal_carre.*signal_buffer);
Y = Y(1:n_fenetre / 2 + 1, :);

 valeurs_t = n_decalage / f_ech * (0:(size(Y, 2) - 1));
 valeurs_f = 0:(f_ech / n_fenetre):f_ech / 2;



