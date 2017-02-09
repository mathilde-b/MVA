function p = gaussian(X, mu, S)
% Compute the gaussian density at points X(i,:)
    % Implicit variabled
    d = size(X,2); K = numel(mu);

    % Case of S = sigma * Id        
    if size(S,1) ~= d
        S = S * eye(d);
    end
    
    Y = bsxfun(@minus, X, mu)';
    % If the gaussian has no density
    try
    [U, D, V] = svd(S);
    catch
        p=0;
        return
    end
    % Only keep invertible direction
    tmp = D > (0.01*D(1,1)); rank = sum(tmp(:));
    if rank == size(S,1)
        p = exp(- sum(Y.*(S\Y),1)/2)' /((2*pi)^(d)*det(S))^(.5);
    else
        Ur = U(:,1:rank); Uk = U(:,rank+1:end); 
        Vr = V(:,1:rank); Dr = D(1:rank,1:rank); 
        yr = Ur' * Y; yp = Vr'*Y; yk = Uk' * Y;
        pen = 100*(D(1,1)^(-1))*sum(yk.*yk);
        p = exp( - pen - sum(yr.*(Dr\yr),1)/2)' /((2*pi)^(d)*det(Dr))^(.5);
    end
end