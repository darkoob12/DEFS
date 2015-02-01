function [P, F] = select(Pop,Fit,NewPop,NewFit)
    %%% survival selection
    % create a pool
    NP = size(Pop,2);
    T_Pop = [Pop NewPop];
    T_Fit = [Fit NewFit];
    [~,ind] = sort(T_Fit);
    
    P = T_Pop(:,ind(1:NP));
    F = T_Fit(ind(1:NP));
end