function [P, F] = natural_select(Pop,Fit,NewPop,NewFit)    
    NP = size(Pop,2);
    F = zeros(1,NP);
    P = zeros(size(Pop));
    
    [~,ind_old] = sort(Pop(end,:));
    [~,ind_new] = sort(NewPop(end,:));
    
    for j = 1:NP
        if Fit(ind_old(j)) < NewFit(ind_new(j))
           P(:,j) = NewPop(:,ind_new(j));
           F(j) = NewFit(ind_new(j));
        else
           P(:,j) = Pop(:,ind_old(j));
           F(j) = Fit(ind_old(j));
        end
    end
end