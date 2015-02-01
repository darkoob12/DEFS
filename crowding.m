function dist = crowding(Pop,Fit,k)
    % distance in the objective space
    function d = distance(i,j)
        d = (Pop(end-1,i) - Pop(end-1,j))^2;
        d = d + (Fit(i) - Fit(j))^2;
        d = sqrt(d);
    end

    function s = size_dist(i,j)
        s = abs(Pop(end-1,i) - Pop(end-1,j));
    end


n = size(Pop,2);
dist = zeros(1,n);
for i = 1:n
    temp = 0;
    % sample k points in the population
    r = randperm(n,k);
    for j = 1:k
        temp = temp + size_dist(i,r(j));% distance(i,r(j));
    end
    dist(i) = temp / k;
end

end