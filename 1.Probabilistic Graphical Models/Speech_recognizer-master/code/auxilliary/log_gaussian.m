function [ proba ] = log_gaussian( x, mu, S )
% Gaussian density computation
    % Implicit variable
    d = size(x,2);
    
    % Case of S = sigma * Id        
    if size(S,1) ~= d
    	S = S * eye(d);
    end
    
    y = bsxfun(@minus, x, mu)';
    
    % If the gaussian has no density
    try 
    [U, D, V] = svd(S);
    catch
        proba = -Inf*ones(size(y,2),1);
        return
    end
    % Only keep invertible direction
    tmp = D > (0.05*D(1,1)); rank = sum(tmp(:));
    if rank == size(S,1)
        proba = - sum(y.*(S\y),1)'/2 - d*log(2*pi)/2 - log(det(S))/2;
    else
        Ur = U(:,1:rank); Uk = U(:,rank+1:end); 
        Vr = V(:,1:rank); Dr = D(1:rank,1:rank); 
        yr = Ur' * y; yp = Vr'*y; yk = Uk' * y;
        pen = 100*(D(1,1)^(-1))*sum(yk.*yk);
        proba = - sum(yp.*(Dr\yr),1)'/2 ...
            - d*log(2*pi)/2 - log(det(Dr))/2 - pen';
    end
end
