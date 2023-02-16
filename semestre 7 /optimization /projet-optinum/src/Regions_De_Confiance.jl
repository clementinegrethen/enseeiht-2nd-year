@doc doc"""

#### Objet

Minimise une fonction de ``\mathbb{R}^{n}`` à valeurs dans ``\mathbb{R}`` en utilisant l'algorithme des régions de confiance. 

La solution approchées des sous-problèmes quadratiques est calculé 
par le pas de Cauchy ou le pas issu de l'algorithme du gradient conjugue tronqué

#### Syntaxe
```julia
xmin, fxmin, flag, nb_iters = Regions_De_Confiance(algo,f,gradf,hessf,x0,option)
```

#### Entrées :

   - algo        : (String) string indicant la méthode à utiliser pour calculer le pas
        - "gct"   : pour l'algorithme du gradient conjugué tronqué
        - "cauchy": pour le pas de Cauchy
   - f           : (Function) la fonction à minimiser
   - gradf       : (Function) le gradient de la fonction f
   - hessf       : (Function) la hessiene de la fonction à minimiser
   - x0          : (Array{Float,1}) point de départ
   - options     : (Array{Float,1})
     - deltaMax       : utile pour les m-à-j de la région de confiance
                      ``R_{k}=\left\{x_{k}+s ;\|s\| \leq \Delta_{k}\right\}``
     - gamma1, gamma2 : ``0 < \gamma_{1} < 1 < \gamma_{2}`` pour les m-à-j de ``R_{k}``
     - eta1, eta2     : ``0 < \eta_{1} < \eta_{2} < 1`` pour les m-à-j de ``R_{k}``
     - delta0         : le rayon de départ de la région de confiance
     - max_iter       : le nombre maximale d'iterations
     - Tol_abs        : la tolérence absolue
     - Tol_rel        : la tolérence relative
     - epsilon       : epsilon pour les tests de stagnation

#### Sorties:

   - xmin    : (Array{Float,1}) une approximation de la solution du problème : 
               ``\min_{x \in \mathbb{R}^{n}} f(x)``
   - fxmin   : (Float) ``f(x_{min})``
   - flag    : (Integer) un entier indiquant le critère sur lequel le programme s'est arrêté (en respectant cet ordre de priorité si plusieurs critères sont vérifiés)
      - 0    : CN1
      - 1    : stagnation du ``x``
      - 2    : stagnation du ``f``
      - 3    : nombre maximal d'itération dépassé
   - nb_iters : (Integer)le nombre d'iteration qu'à fait le programme

#### Exemple d'appel
```julia
algo="gct"
f(x)=100*(x[2]-x[1]^2)^2+(1-x[1])^2
gradf(x)=[-400*x[1]*(x[2]-x[1]^2)-2*(1-x[1]) ; 200*(x[2]-x[1]^2)]
hessf(x)=[-400*(x[2]-3*x[1]^2)+2  -400*x[1];-400*x[1]  200]
x0 = [1; 0]
options = []
xmin, fxmin, flag, nb_iters = Regions_De_Confiance(algo,f,gradf,hessf,x0,options)
```
"""
function Regions_De_Confiance(algo,f::Function,gradf::Function,hessf::Function,x0,options)

    if options == []
        deltaMax = 10
        gamma1 = 0.5
        gamma2 = 2.00
        eta1 = 0.25
        eta2 = 0.75
        delta0 = 2
        max_iter = 1000
        Tol_abs = sqrt(eps())
        Tol_rel = 1e-15
        epsilon = 1.e-2
    else
        deltaMax = options[1]
        gamma1 = options[2]
        gamma2 = options[3]
        eta1 = options[4]
        eta2 = options[5]
        delta0 = options[6]
        max_iter = options[7]
        Tol_abs = options[8]
        Tol_rel = options[9]
        epsilon = options[10]
    end

    n = length(x0)
    xmin = zeros(n)
    fxmin = f(xmin)
    flag = 0
    nb_iters = 0
    bool=false
    xk = x0
    xk_1 = x0
    # tant que non arret 
    # Cn1
        while (norm(gradf(xk)) > max(Tol_rel * norm(gradf(x0)), Tol_abs))
            bool=false
            xk_1=xk
            nb_iters=nb_iters+1
            # solution du min de mk(s) avec la méthode au choix : gct ou cauchy
            if algo == "gct"
                (sk) = Gradient_Conjugue_Tronque(gradf(xk),hessf(xk),[delta0;max_iter;Tol_rel])
            elseif algo == "cauchy"
                (sk,e) = Pas_De_Cauchy(gradf(xk),hessf(xk),delta0)
            end

            mk_s=f(xk)+gradf(xk)'*sk+0.5*sk'*hessf(xk)*sk
            mk_zero= f(xk)
            
            ro= (f(xk)-f(xk+sk))/(mk_zero-mk_s)
            if ro>= eta1
                bool=true
                xk=xk_1+sk # mise à jour de xk
            end
            if ro>= eta2
                delta0=min(deltaMax,delta0*gamma2) #On augmente la région de confiance

            elseif ro >= eta1
                delta0=delta0
            else  # on diminue la région de confiance
                delta0 =gamma1 * delta0
            end

            # CN#
            if norm(gradf(xk)) <= max(Tol_abs, Tol_rel * norm(gradf(x0)))
                flag = 0
                break
            # stagnation du x 
            elseif norm(xk-xk_1) <= max(Tol_abs, Tol_rel * norm(xk))*epsilon && bool
                flag = 1
                break
            # stagnation du f
            elseif abs(f(xk_1) - f(xk)) <= max(Tol_abs, Tol_rel * abs(f(xk_1)))*epsilon && bool
                flag = 2
                break
            # nombre maximal d'itération dépassé
            elseif nb_iters == max_iter
                flag = 3
                break
            end

            
            

        end
        xmin=xk
        fxmin=f(xk)
        

    return xmin,fxmin,flag,nb_iters

end
