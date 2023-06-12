function identifiants = indexation_triplets(triplets)
    f1_f2 = rem(triplets(:, 1) ./ triplets(:, 2), 2^8);
    f2_f3 = rem(triplets(:, 2) ./ triplets(:, 3), 2^8);
    identifiants = uint32(f1_f2 * 2^16 + f2_f3);
end
