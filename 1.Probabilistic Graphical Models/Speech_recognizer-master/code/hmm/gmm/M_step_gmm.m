function [ pi, mu, Sigma ] = M_step_gmm( X, q )
% Maximization of the joint likelihood
    K = size(q,2); d = size(X,2);

    % Preallocation
    mu = cell(K,1);
    Sigma = cell(K,1);

    % Maximization in pi non normalized
    pi = sum(q,1);

    % Maximization in mu
    for k=1:K
        mu{k} =  sum(X.*repmat(q(:,k), 1,size(X,2)),1)/pi(k);
    end

    % Maximization in Sigma
    for k=1:K
        Y = bsxfun(@minus, X, mu{k});
        Sigma{k} = Y'*(Y.*repmat(q(:,k), 1,size(X,2)))/pi(k);
    end

    % Normalization of pi
    pi = bsxfun(@rdivide, pi, sum(pi));
end
