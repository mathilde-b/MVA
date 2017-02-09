function [ hidden ] = E_step_hmm( u, parameter, met)
% Return gamma and eta as described in the paper
    % Implicit arguments
    K = size(parameter.a,1); T = size(u,1); M = size(parameter.s,2);

    %% Foward recursion
    log_alpha = zeros(T, K); % log(alpha)

    % Initialization
    % Add p(q_1,u_1)
    log_alpha(1,:) = -Inf;
    log_alpha(1,1) = log_mixture(u(1,:), parameter, 1); 
    
    % Induction
    for t=2:T
        for k=1:K
           % Add p(u_t|q_t=k)
            log_alpha(t,k) = log_mixture(u(t,:),parameter,k);
        end
        % Add sum(p(q_t=k|q_t-1)*alpha(t-1,q_t-1))
        sum_tmp = bsxfun(@plus, log(parameter.a), log_alpha(t-1,:)');
        log_alpha(t,:) = log_alpha(t,:) + log_sum(sum_tmp);
    end

    %% Backward recursion
    log_beta = zeros(T,K);
    % Initialisation
    log_beta(T,:) = ones(1,K);

    % Induction
    for t=T-1:-1:1
        u_tmp = zeros(K,1);
        for k=1:K
            u_tmp(k) = log_mixture(u(t,:),parameter,k);
        end
        sum_tmp = bsxfun(@plus, log(parameter.a)', log_beta(t+1,:)' + u_tmp );
        log_beta(t,:) = log_sum(sum_tmp);
    end

    %% Probability computation
    % Gamma
    % Add p(q|o)
    log_gamma = log_alpha + log_beta;
    % Normalization
    log_gamma = log_gamma - log_sum(log_gamma,2);
    % Add p(c|q,o);
    log_gamma = repmat(log_gamma, 1,1,M);
    for i=1:K
        tmp = zeros(T,M);
        for m = 1:M
            tmp(:,m) = log_gaussian(u, parameter.mu{i,m}', parameter.U{i,m});
        end
        tmp = tmp - log_sum(tmp,2);
        log_gamma(:,i,:) = log_gamma(:,i,:) + reshape(tmp,[T,1,M]);
    end
    hidden.gamma = exp(log_gamma);

    % Eta
    % Add log_alpha(t,q_t)
    log_eta = repmat(log_alpha(1:T-1,:), [1 1 K]);
    % Add log_beta(t+1,q_t+1)
    log_eta = log_eta + repmat(reshape(log_beta(2:T,:),[T-1,1,K]),[1,K,1]);
    % Add p(q_t+1|q_t)
    log_eta = log_eta + repmat(reshape(log(parameter.a),[1,K,K]),[T-1,1,1]);
    % Add p(u_t+1|q_t+1)
    for l=1:K
        u_tmp = log_mixture(u(2:T,:),parameter,l);
        log_eta(:,:,l) = log_eta(:,:,l) + repmat(reshape(u_tmp,[T-1,1,1]),[1,K,1]);
    end
    % Normalization
    log_eta = log_eta - log_sum(reshape(log_eta, [T-1, K*K])')';
    hidden.eta = exp(log_eta);
end
