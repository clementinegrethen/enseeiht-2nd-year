@doc doc"""
#### Objet
Cette fonction calcule une solution approchée du problème

```math
\min_{||s||< \Delta}  q(s) = s^{t} g + \frac{1}{2} s^{t}Hs
```

par l'algorithme du gradient conjugué tronqué

#### Syntaxe
```julia
s = Gradient_Conjugue_Tronque(g,H,option)
```

#### Entrées :   
   - g : (Array{Float,1}) un vecteur de ``\mathbb{R}^n``
   - H : (Array{Float,2}) une matrice symétrique de ``\mathbb{R}^{n\times n}``
   - options          : (Array{Float,1})
      - delta    : le rayon de la région de confiance
      - max_iter : le nombre maximal d'iterations
      - tol      : la tolérance pour la condition d'arrêt sur le gradient

#### Sorties:
   - s : (Array{Float,1}) le pas s qui approche la solution du problème : ``min_{||s||< \Delta} q(s)``

#### Exemple d'appel:
```julia
gradf(x)=[-400*x[1]*(x[2]-x[1]^2)-2*(1-x[1]) ; 200*(x[2]-x[1]^2)]
hessf(x)=[-400*(x[2]-3*x[1]^2)+2  -400*x[1];-400*x[1]  200]
xk = [1; 0]
options = []
s = Gradient_Conjugue_Tronque(gradf(xk),hessf(xk),options)
```
"""
 # on cherche une approximation de la solution au sous-problème min q(s)
function Gradient_Conjugue_Tronque(g,H,options)

  # calcul de la fonction q 
    function q(x) 
        return (g'*x) + (0.5*(x'*H*x))
      end

  # fonction auxiliaire 
    function sig(pj,sj,deltak)
        sigj = 0
        a = norm(pj)^2
        b = 2*(pj'*sj)
        c = (norm(sj)^2)-(deltak^2)
        d = b^2 - (4*a*c)
        if d > 0
          sig1 = (- b + sqrt(d)) / (2*a)
          sig2 = (- b - sqrt(d)) / (2*a)
          q1 = q(sj + sig1*pj)
          q2 = q(sj + sig2*pj)
          sigj = 0
          if q1 < q2
            sigj = sig1
          else 
            sigj = sig2
          end
        elseif d==0 
          sigj = - b / (2*a)
        end 
        return sigj
    end

    "# Si option est vide on initialise les 3 paramètres par défaut"
    if options == []
        delta = 2
        max_iter = 100
        tol = 1e-6
    else
        delta = options[1]
        max_iter = options[2]
        tol = options[3]
    end

    n = length(g)
    s = zeros(n)
    j=0
    g0=g
    gj=g
    s0= zero(n)
    sj=s
    p0= -g
    pj=-g
    norm_go = norm(g)

    if norm_go == 0
        return s
    end

    while j< max_iter && norm(gj) >= max( norm_go* tol,tol)
        kj= (pj'*H*pj)

        if (kj <= 0) 
          # σj ← la racine de ∥sj + σpj∥ = ∆ pour laquelle q(sj + σpj) est la plus petite, on utilise la fonction auxiliaire sig
            sigj = sig(pj,sj,delta)
            s = sj + (sigj * pj)
            return s
         end

         alphaj = (norm(gj)^2) /kj

        if (norm(sj + (alphaj)*pj) > delta) 
          #σj ← la racine positive de ∥sj + σpj∥ = ∆, on utilise la fonction auxiliaire sig
            sigj = sig(pj,sj,delta)
            s = sj + (sigj * pj)
            return s
        end

        sj = sj + (alphaj * pj)
        gj1 = gj + (alphaj * H * pj)
        betaj = (gj1'*gj1)/(gj'*gj)
        pj = -gj1 + (betaj * pj)
        gj = gj1
        j = j+1
    end

   return sj
end

