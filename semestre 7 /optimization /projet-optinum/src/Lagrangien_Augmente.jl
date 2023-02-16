@doc doc"""
#### Objet

Résolution des problèmes de minimisation avec une contrainte d'égalité scalaire par l'algorithme du lagrangien augmenté.

#### Syntaxe
```julia
xmin,fxmin,flag,iter,muks,lambdaks = Lagrangien_Augmente(algo,f,gradf,hessf,c,gradc,hessc,x0,options)
```

#### Entrées
  - algo : (String) l'algorithme sans contraintes à utiliser:
    - "newton"  : pour l'algorithme de Newton
    - "cauchy"  : pour le pas de Cauchy
    - "gct"     : pour le gradient conjugué tronqué
  - f : (Function) la fonction à minimiser
  - gradf       : (Function) le gradient de la fonction
  - hessf       : (Function) la hessienne de la fonction
  - c     : (Function) la contrainte [x est dans le domaine des contraintes ssi ``c(x)=0``]
  - gradc : (Function) le gradient de la contrainte
  - hessc : (Function) la hessienne de la contrainte
  - x0 : (Array{Float,1}) la première composante du point de départ du Lagrangien
  - options : (Array{Float,1})
    1. epsilon     : utilisé dans les critères d'arrêt
    2. tol         : la tolérance utilisée dans les critères d'arrêt
    3. itermax     : nombre maximal d'itération dans la boucle principale
    4. lambda0     : la deuxième composante du point de départ du Lagrangien
    5. mu0, tho    : valeurs initiales des variables de l'algorithme

#### Sorties
- xmin : (Array{Float,1}) une approximation de la solution du problème avec contraintes
- fxmin : (Float) ``f(x_{min})``
- flag : (Integer) indicateur du déroulement de l'algorithme
   - 0    : convergence
   - 1    : nombre maximal d'itération atteint
   - (-1) : une erreur s'est produite
- niters : (Integer) nombre d'itérations réalisées
- muks : (Array{Float64,1}) tableau des valeurs prises par mu_k au cours de l'exécution
- lambdaks : (Array{Float64,1}) tableau des valeurs prises par lambda_k au cours de l'exécution

#### Exemple d'appel
```julia
using LinearAlgebra
algo = "gct" # ou newton|gct
f(x)=100*(x[2]-x[1]^2)^2+(1-x[1])^2
gradf(x)=[-400*x[1]*(x[2]-x[1]^2)-2*(1-x[1]) ; 200*(x[2]-x[1]^2)]
hessf(x)=[-400*(x[2]-3*x[1]^2)+2  -400*x[1];-400*x[1]  200]
c(x) =  (x[1]^2) + (x[2]^2) -1.5
gradc(x) = [2*x[1] ;2*x[2]]
hessc(x) = [2 0;0 2]
x0 = [1; 0]
options = []
xmin,fxmin,flag,iter,muks,lambdaks = Lagrangien_Augmente(algo,f,gradf,hessf,c,gradc,hessc,x0,options)
```

#### Tolérances des algorithmes appelés

Pour les tolérances définies dans les algorithmes appelés (Newton et régions de confiance), prendre les tolérances par défaut définies dans ces algorithmes.

"""


function Lagrangien_Augmente(algo,fonc::Function,contrainte::Function,gradfonc::Function,
        hessfonc::Function,grad_contrainte::Function,hess_contrainte::Function,x0,options)

  if options == []
		epsilon = 1e-2
		tol = 1e-5
		itermax = 1000
		lambda0 = 2
		mu0 = 100
		tho = 2
	else
		epsilon = options[1]
		tol = options[2]
		itermax = options[3]
		lambda0 = options[4]
		mu0 = options[5]
		tho = options[6]
	end
  nb_iter = 0
  n = length(x0)
  xmin = zeros(n)
  fxmin = 0
  muk = mu0
  muks = [mu0]
  lambdak = lambda0
  lambdaks = [lambda0]
  
  x = x0
  beta = 0.9
  etat = 0.1258925
  alpha = 0.1
  eps0 = 1/mu0
  epsk = eps0
  etatk = etat/(mu0)^(alpha)
  stagx = false #stagnation de x
  stagf = false #stagnation de f

  # Initialisation de la fonction Lagrangienne
  function LA_init(x)
    return fonc(x) + lambdak' * contrainte(x) + muk/2 * norm(contrainte(x))^2
  end

  flag = 0

#  condition nécessaire 1
  condition_arret = ( norm(LA_init(x)) <= eps0) 

  function La(x)
    return fonc(x) + lambdak' * contrainte(x) + muk/2 * norm(contrainte(x))^2
  end
# gradien de la fonction Lagrangienne
  function grad_LA(x)
    return gradfonc(x) + lambdak' * grad_contrainte(x) + muk * contrainte(x) * grad_contrainte(x)
  end 
# hessienne de la fonction Lagrangienne
  function hess_LA(x)
    return hessfonc(x) + lambdak' * hess_contrainte(x) + muk * (grad_contrainte(x) * grad_contrainte(x)' + contrainte(x) * hess_contrainte(x))
  end




# condition nécessaire 1
  while nb_iter < itermax && !CN1 && !stagnation_xk && !stagnation_f

  # choix de l'algorithme
    if algo == "newton"
      xk  = Algorithme_De_Newton(La,grad_LA,hess_LA,x,[])[1]
    else
      xk = Regions_De_Confiance(algo,La,grad_LA,hess_LA,x,[])[1]
    end 

    if norm(contrainte(xk)) >= etatk
      muk = tho*muk
      epsk = eps0/muk
      etatk = etat/(muk^alpha)
    else 
      lambdak = lambdak + muk*contrainte(xk)
      epsk = epsk/muk
      etatk = etatk/(muk^beta)
    end
    #mise à jour des tableaux
    push!(muks, muk)
    push!(lambdaks,lambdak)      
    # mise à jour des conditions d'arrêt
    stagx = (norm(xk - x) <= epsk)
    stagf = (abs(fonc(xk) - fonc(x)) <= epsk)
    condition_arret = ( norm(La(xk)) <= epsk ) 
    # mise à jour de x
    x = xk
    # mise à jour du nombre d'itérations
    nb_iter = nb_iter + 1

  end
  
  if nb_iter == itermax
    flag = 1
  end      

  return x,fonc(x),flag,nb_iter, muks, lambdaks
end
