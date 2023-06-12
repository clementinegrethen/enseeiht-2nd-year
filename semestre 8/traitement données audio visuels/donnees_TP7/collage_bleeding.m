function u = collage_bleeding(r, s, interieur)
    % Conversion au format double
    r = double(r);
    s = double(s);
    u = r;
    
    [n, m, l] = size(r);
    e = ones(n*m, 1);
    
    Dx = spdiags([-e e], [0 n], n*m, m*n);
    Dx(end-n+1:end, :) = 0;
    
    Dy = spdiags([-e e], [0 1], n*m, n*m);
    Dy(n:n:end, :) = 0;
    
    A = -Dx'*Dx - Dy'*Dy;
    
    % Convertir le vecteur interieur en masque binaire
    masque = zeros(n, m);
    masque(interieur) = 1;
    
    % Imposer la condition de bord u = r sur le bord et à l'extérieur du masque
    masque_bord = ones(n, m) - masque;
    indices_bord_masque = find(masque_bord);
    n_bord_masque = length(indices_bord_masque);
    n_masque = n*m;
    A(indices_bord_masque, :) = sparse(1:n_bord_masque, indices_bord_masque, ones(n_bord_masque, 1), n_bord_masque, n_masque);
    
    for k = 1:l
        u_k = u(:, :, k);
        s_k = s(:, :, k);
        
        grad_x_u = Dx*u_k(:);
        grad_y_u = Dy*u_k(:);
        
        grad_x_s = Dx*s_k(:);
        grad_y_s = Dy*s_k(:);
        
        % Choisir le gradient avec la plus grande magnitude
        grad_x = grad_x_u;
        grad_y = grad_y_u;
        indices = find(sqrt(grad_x_s.^2 + grad_y_s.^2) > sqrt(grad_x_u.^2 + grad_y_u.^2));
        grad_x(indices) = grad_x_s(indices);
        grad_y(indices) = grad_y_s(indices);
        
        b_k = -Dx'*grad_x - Dy'*grad_y;
        b_k(indices_bord_masque) = u_k(indices_bord_masque);
        
        u_k = A\b_k;
        u(:, :, k) = reshape(u_k, n, m);
    end
end
