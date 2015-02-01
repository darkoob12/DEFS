function n_pop = recombination(Pop,parents,CR,c1,mu)
NF = size(Pop,1) - 2;   % number of features
NP = size(Pop,2);
n_pop = zeros(size(Pop));   % new population
X = zeros(NF+2,1);

% create mutant population
for j = 1:NP
    % choose three random individuals from population,
    r = randperm(NP,3);
    
    % a randomly selected feature that will definitly change
    rnd_feature = floor(rand()*NF) + 1;
    
    % applying de variation operator
    for i = 1:NF
        if (rand() > CR) || (rnd_feature == i)   % eq. 2
            F = (c1 * rand()) / max(Pop(i,r(2)),Pop(i,r(3))); %eq. 3
            X(i) = Pop(i,r(1)) - F * (Pop(i,r(2)) - Pop(i, r(3))); %eq. 1
            % variate adaptive parameters (size of feature subset)
            X(end - 1) = Pop(end-1,parents(j)) + Pop(end, parents(j)) * randn;
            % self-adaptation
            X(end) = Pop(end,parents(j))* exp(mu * randn);
            % verify boundary constraints on size variable
            if X(end-1) < 1
                X(end-1) = 1;
            elseif X(end-1) > NF
                X(end-1) = NF;
            end
        else
            X(i) = Pop(i,parents(j));
            X(end-1) = Pop(end-1,parents(j));
            X(end) = Pop(end,parents(j));
        end
    end
    
    % save new chromosme
    n_pop(:,j) = X;
end
end