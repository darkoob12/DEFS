function n_pop = recombination(Pop,parents,CR,c1)
NF = size(Pop,1) - 1;   % number of features
NP = size(Pop,2);
n_pop = zeros(size(Pop));   % new population
X = zeros(NF+1,1);

% create mutant population
for j = 1:NP
    % choose three random individuals from population,
    r = randperm(NP,3);
    
    % a randomly selected feature that will definitly change
    rnd_feature = randi(NF,1);
    
    % applying de variation operator
    for i = 1:NF
        if (rand() > CR) || (rnd_feature == i)   % eq. 2
            F = (c1 * rand()) / max(Pop(i,r(2)),Pop(i,r(3))); %eq. 3
            X(i) = Pop(i,r(1)) + F * (Pop(i,r(2)) - Pop(i, r(3))); %eq. 1
        else
            X(i) = Pop(i,parents(j));
        end 
    end
    
    % fix possible boundary violation
    X(end) = CR*Pop(end, parents(j)) + (1-CR)*Pop(end,r(1));
    if X(end) < 1
        X(end) = 1;
    elseif X(end) > NF
        X(end) = NF;
    end
    % save new chromosme
    n_pop(:,j) = X;
end
end