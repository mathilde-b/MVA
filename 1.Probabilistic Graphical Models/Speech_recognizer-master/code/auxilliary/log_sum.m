function [ res ] = log_sum( log_a, dim )
% Perform res = log(sum(a)); input is log(a)
% res = log(a_*)  + log(sum(exp(log(a)-log(a_*)))
    if nargin<2, dim = 1; end;
    log_a_max = max(log_a,[],dim);
    res = log_a_max + log(sum(exp(log_a - log_a_max),dim));
    res(isnan(res)) = -Inf;
end

