function [ hidden_max ] = Viterbi_decoding( u, parameter, met )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    % implicit parameter
    K = size(parameter.a,1); T = size(u,1); M = size(parameter.s,2);
    
    % Foward pass
    log_xi_current = -Inf.*ones(1,K);
    log_xi_current(1) = 0;
    
    q = zeros(T-1,K);
    for t=2:T
        log_xi_prior = log_xi_current;
        tmp=zeros(K,K);        
        for k=1:K
            tmp(:,k) = log_xi_prior(k) + log_mixture(u(t-1,:),...
                parameter, k) + log(parameter.a(k,:))';
        end
        [log_xi_current, q(t-1,:)] = max(tmp,[],2);
    end
    
    % Backward pass
    q_max = zeros(T,1); tmp_max = -Inf; ind_max=K;
    for k=1:K
        tmp = log_xi_current(k) + log_mixture(u(T,:),parameter,k);
        if tmp > tmp_max
            tmp_max = tmp; ind_max=k;
        end
    end
    q_max(T) = ind_max;
    for t=T-1:-1:1
        q_max(t) = q(t,q_max(t+1));
    end
    hidden_max.q = q_max;
    
    c_max = zeros(T, 1);
    for t=1:T
        k = q(t);
        pi = parameter.s(k,:);
        mu = cell(M,1); Sigma = cell(M,1);
        for m=1:M
            mu{m} = parameter.mu{k,m}'; Sigma{m} = parameter.U{k,m};
        end
        tmp = E_step_gmm(u(t,:), pi, mu, Sigma);
        [~,y] = max(tmp, [],2);
        c_max(t) = y;
    end
    hidden_max.c = c_max;
end
