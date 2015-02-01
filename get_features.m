function b_features = get_features(chrom)
    b_size = round(chrom(end - 1));   % size of best chromosome
    [~, b_features] = sort(chrom(1:end-2), 'descend');
    b_features = b_features(1:b_size);
end