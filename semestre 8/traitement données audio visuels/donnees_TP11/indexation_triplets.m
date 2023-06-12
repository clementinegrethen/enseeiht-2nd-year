function identifiants = indexation_triplets(triplets)
    f1_f2 = rem(triplets(:, 1) ./ triplets(:, 2), 2^8);
    f2_f3 = rem(triplets(:, 2) ./ triplets(:, 3), 2^8);
    t21 = rem(triplets(:, 5) - triplets(:, 4), 2^16);
    t32 = rem(triplets(:, 6) - triplets(:, 5), 2^16);
    identifiants = uint32(f1_f2 * 2^24 + f2_f3 * 2^16 + t21 * 2^8 + t32);
end
