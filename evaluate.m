function Fit = evaluate(Pop, data_ts, data_tr, classif)
    NP = size(Pop,2);
    Fit = zeros(1,NP);
    for j = 1:NP 
        Fit(1,j) = fitness_ind(Pop(:,j), data_ts, data_tr, classif);
    end
end