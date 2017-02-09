function [ p ] = log_mixture( X, parameter, i)
% Compute log(sum_m(s(i,m)*gaussian(X,mu(i,m),U(i,m))
    tmp = repmat(log(parameter.s(i,:)),[size(X,1),1]);
    for m=1:size(tmp,2)
        tmp(:,m) = tmp(:,m) + log_gaussian(X, parameter.mu{i,m}', parameter.U{i,m});
    end
    p = log_sum(tmp');
end

