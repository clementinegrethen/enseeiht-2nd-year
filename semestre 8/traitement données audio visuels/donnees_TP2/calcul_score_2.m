function score = calcul_score_2(parametres_1_VT,parametres_2_VT,parametres_1_estim,parametres_2_estim)

score_1_1 = calcul_score(parametres_1_VT,parametres_1_estim);
score_2_2 = calcul_score(parametres_2_VT,parametres_2_estim);
score_sans_echange = (score_1_1+score_2_2)/2;

score_2_1 = calcul_score(parametres_2_VT,parametres_1_estim);
score_1_2 = calcul_score(parametres_1_VT,parametres_2_estim);
score_avec_echange = (score_2_1+score_1_2)/2;

score = max(score_sans_echange,score_avec_echange);
