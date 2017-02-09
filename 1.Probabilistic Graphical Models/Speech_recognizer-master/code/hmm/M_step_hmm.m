function [ parameter ] = M_step_hmm( Xs, hidden, met )
% Maximization of the joint likelihood
    % eta = eta(t+rT, i, j)
    % gamma = gamma(t+rT, i, m)
    
    % Implicit variables
    eta = hidden.eta; gamma = hidden.gamma; 
    K = size(gamma,2); M = size(gamma,3); R = size(Xs,2); % S = size(X,2);

    X = [];
    for r = 1:R
        X = [X; Xs{r}];
    end
    
    % Object creation
    mu = cell(K,M); Sigma = cell(K,M);

    % Maximization in a
    a = reshape(sum(eta,1),[K,K]);
    parameter.a = a./sum(a,2);
    % Correcting border effects
    parameter.a(1,K) = 0; parameter.a(K,K) = 1;
    
    % Maxmization in s
    s = reshape(sum(gamma,1),[K,M]);
    parameter.s = s./sum(s,2);

    % Maximization for the Gaussians
    for k=1:K
        for m=1:M
            tmp = sum(gamma(:,k,m));
            mu{k,m} = sum(X.*gamma(:,k,m))'/tmp;
            Y = bsxfun(@minus, X, mu{k,m}');
            Sigma{k,m} = Y'*(Y.*gamma(:,k,m))/tmp;
        end
    end
    parameter.mu = mu;
    parameter.U = Sigma;
end
