function [ proba ] = dirac2proba( dirac, opts )
% eta(t,i,j) = (q(t)=i)(q(t+1)=j)
% gamma(t,i,m) = (q(t)=i)(c(t)=m)
    % Implicit parameter
    q = dirac.q; c = dirac.c;
    K = opts.K; M=opts.M; T = size(q,1);
    % Logical array
    q_ind = cumsum(ones(T,K),2)==q ;
    c_ind = cumsum(ones(T,M),2)==c ;
    % Solution
    proba.gamma = repmat(q_ind,1,1,M).*repmat(reshape(c_ind, [T,1,M]),1,K,1);
    proba.eta = repmat(q_ind(1:end-1,:), 1, 1, K) .* ...
        repmat(reshape(q_ind(2:end,:), [T-1,1,K]), 1, K, 1);
end

