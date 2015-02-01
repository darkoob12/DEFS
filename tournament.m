function sel = tournament(Fit,N,k)
    sel = zeros(1,N);
    NP = length(Fit);
    for i = 1:N
        % select k random solutions
        rand_index = randperm(NP,k);
        [~, best] = min(Fit(rand_index));
        sel(i) = rand_index(best);
    end
end