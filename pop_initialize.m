function pop = pop_initialize(Ld,NF,NP)
    % initialize random number generator
    rng('shuffle');
    if Ld,
        load Pop;
    else
        pop = zeros(NF+1,NP);
        for j=1:NP,
            mu = mean(1:NF);
            sig = std(1:NF);
            % chromosome
            pop(1:NF,j) = rand(NF,1);
            % adaptive parameters
            pop(end,j) = mu + randn * sig;
            if pop(end,j) > NF
                pop(end,j) = NF - abs(randn);
            elseif pop(end,j) < 1
                pop(end,j) = 1 + abs(randn);
            end
        end
    end
end