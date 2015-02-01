function parents = parent_selection(Fit, NP)
    % parent selection using rank based sus sampling from wheel
    expectation = fitscalingrank(Fit,NP);
    parents = selectionstochunif(expectation,NP);
    parents = parents(randperm(length(parents))); 
end