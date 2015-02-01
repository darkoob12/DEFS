function pop = pop_initialize(Ld,NF,NP)
    % initialize random number generator
    rng('shuffle');
    if Ld,
        load Pop;
    else
        pop = zeros(NF+2,NP);
        for j=1:NP,
            % chromosome
            pop(1:NF,j) = rand(NF,1);
            % adaptive parameters
            pop(NF+1,j) = randi(round(NF/4),1);
            % momentume of adaptation
            pop(NF+2,j) = rand();
        end
    end
end